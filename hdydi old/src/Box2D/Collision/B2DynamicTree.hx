/*
* Copyright (c) 2009 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

package box2D.collision;

import haxe.Constraints.Function;
import box2D.common.*;
import box2D.common.math.*;

// A dynamic AABB tree broad-phase, inspired by Nathanael Presson's btDbvt.
/**
	 * A dynamic tree arranges data in a binary tree to accelerate
	 * queries such as volume queries and ray casts. Leafs are proxies
	 * with an AABB. In the tree we expand the proxy AABB by b2_fatAABBFactor
	 * so that the proxy AABB is bigger than the client object. This allows the client
	 * object to move by small amounts without triggering a tree update.
	 * 
	 * Nodes are pooled.
	 */
class B2DynamicTree
{
    /**
		 * Constructing the tree initializes the node pool.
		 */
    public function new()
    {
        m_root = null;
        
        // TODO: Maybe allocate some free nodes?
        m_freeList = null;
        m_path = 0;
        
        m_insertionCount = 0;
    }
    /*
		public function Dump(node:b2DynamicTreeNode=null, depth:int=0):void
		{
			if (!node)
			{
				node = m_root;
			}
			if (!node) return;
			for (var i:int = 0; i < depth; i++) s += " ";
			if (node.userData)
			{
				var ud:* = (node.userData as b2Fixture).GetBody().GetUserData();
				trace(s + ud);
			}else {
				trace(s + "-");
			}
			if (node.child1)
				Dump(node.child1, depth + 1);
			if (node.child2)
				Dump(node.child2, depth + 1);
		}
		*/
    
    /**
		 * Create a proxy. Provide a tight fitting AABB and a userData.
		 */
    public function CreateProxy(aabb : B2AABB, userData : Dynamic) : B2DynamicTreeNode
    {
        var node : B2DynamicTreeNode = AllocateNode();
        
        // Fatten the aabb.
        var extendX : Float = b2Settings.b2_aabbExtension;
        var extendY : Float = b2Settings.b2_aabbExtension;
        node.aabb.lowerBound.x = aabb.lowerBound.x - extendX;
        node.aabb.lowerBound.y = aabb.lowerBound.y - extendY;
        node.aabb.upperBound.x = aabb.upperBound.x + extendX;
        node.aabb.upperBound.y = aabb.upperBound.y + extendY;
        
        node.userData = userData;
        
        cast((node), InsertLeaf);
        return node;
    }
    
    /**
		 * Destroy a proxy. This asserts if the id is invalid.
		 */
    public function DestroyProxy(proxy : B2DynamicTreeNode) : Void
    //b2Settings.b2Assert(proxy.IsLeaf());
    {
        
        cast((proxy), RemoveLeaf);
        cast((proxy), FreeNode);
    }
    
    /**
		 * Move a proxy with a swept AABB. If the proxy has moved outside of its fattened AABB,
		 * then the proxy is removed from the tree and re-inserted. Otherwise
		 * the function returns immediately.
		 */
    public function MoveProxy(proxy : B2DynamicTreeNode, aabb : B2AABB, displacement : B2Vec2) : Bool
    {
        b2Settings.b2Assert(proxy.IsLeaf());
        
        if (proxy.aabb.Contains(aabb))
        {
            return false;
        }
        
        cast((proxy), RemoveLeaf);
        
        // Extend AABB
        var extendX : Float = b2Settings.b2_aabbExtension + b2Settings.b2_aabbMultiplier * ((displacement.x > 0) ? displacement.x : -displacement.x);
        var extendY : Float = b2Settings.b2_aabbExtension + b2Settings.b2_aabbMultiplier * ((displacement.y > 0) ? displacement.y : -displacement.y);
        proxy.aabb.lowerBound.x = aabb.lowerBound.x - extendX;
        proxy.aabb.lowerBound.y = aabb.lowerBound.y - extendY;
        proxy.aabb.upperBound.x = aabb.upperBound.x + extendX;
        proxy.aabb.upperBound.y = aabb.upperBound.y + extendY;
        
        cast((proxy), InsertLeaf);
        return true;
    }
    
    /**
		 * Perform some iterations to re-balance the tree.
		 */
    public function Rebalance(iterations : Int) : Void
    {
        if (m_root == null)
        {
            return;
        }
        
        for (i in 0...iterations)
        {
            var node : B2DynamicTreeNode = m_root;
            var bit : Int = 0;
            while (node.IsLeaf() == false)
            {
                node = ((as3hx.Compat.parseInt(m_path >> bit) & 1) != 0) ? node.child2 : node.child1;
                bit = as3hx.Compat.parseInt(bit + 1) & 31;
            }
            ++m_path;
            
            cast((node), RemoveLeaf);
            cast((node), InsertLeaf);
        }
    }
    
    public function GetFatAABB(proxy : B2DynamicTreeNode) : B2AABB
    {
        return proxy.aabb;
    }
    
    /**
		 * Get user data from a proxy. Returns null if the proxy is invalid.
		 */
    public function GetUserData(proxy : B2DynamicTreeNode) : Dynamic
    {
        return proxy.userData;
    }
    
    /**
		 * Query an AABB for overlapping proxies. The callback
		 * is called for each proxy that overlaps the supplied AABB.
		 * The callback should match function signature
		 * <code>fuction callback(proxy:b2DynamicTreeNode):Boolean</code>
		 * and should return false to trigger premature termination.
		 */
    public function Query(callback : Function, aabb : B2AABB) : Void
    {
        if (m_root == null)
        {
            return;
        }
        
        var stack : Array<B2DynamicTreeNode> = new Array<B2DynamicTreeNode>();
        
        var count : Int = 0;
        stack[count++] = m_root;
        
        while (count > 0)
        {
            var node : B2DynamicTreeNode = stack[--count];
            
            if (node.aabb.TestOverlap(aabb))
            {
                if (node.IsLeaf())
                {
                    var proceed : Bool = callback(node);
                    if (!proceed)
                    {
                        return;
                    }
                }
                // No stack limit, so no assert
                else
                {
                    
                    stack[count++] = node.child1;
                    stack[count++] = node.child2;
                }
            }
        }
    }
    
    /**
		 * Ray-cast against the proxies in the tree. This relies on the callback
		 * to perform a exact ray-cast in the case were the proxy contains a shape.
		 * The callback also performs the any collision filtering. This has performance
		 * roughly equal to k * log(n), where k is the number of collisions and n is the
		 * number of proxies in the tree.
		 * @param input the ray-cast input data. The ray extends from p1 to p1 + maxFraction * (p2 - p1).
		 * @param callback a callback class that is called for each proxy that is hit by the ray.
		 * It should be of signature:
		 * <code>function callback(input:b2RayCastInput, proxy:*):void</code>
		 */
    public function RayCast(callback : Function, input : B2RayCastInput) : Void
    {
        if (m_root == null)
        {
            return;
        }
        
        var p1 : B2Vec2 = input.p1;
        var p2 : B2Vec2 = input.p2;
        var r : B2Vec2 = b2Math.SubtractVV(p1, p2);
        //b2Settings.b2Assert(r.LengthSquared() > 0.0);
        r.Normalize();
        
        // v is perpendicular to the segment
        var v : B2Vec2 = b2Math.CrossFV(1.0, r);
        var abs_v : B2Vec2 = b2Math.AbsV(v);
        
        var maxFraction : Float = input.maxFraction;
        
        // Build a bounding box for the segment
        var segmentAABB : B2AABB = new B2AABB();
        var tX : Float;
        var tY : Float;
        {
            tX = p1.x + maxFraction * (p2.x - p1.x);
            tY = p1.y + maxFraction * (p2.y - p1.y);
            segmentAABB.lowerBound.x = Math.min(p1.x, tX);
            segmentAABB.lowerBound.y = Math.min(p1.y, tY);
            segmentAABB.upperBound.x = Math.max(p1.x, tX);
            segmentAABB.upperBound.y = Math.max(p1.y, tY);
        }
        
        var stack : Array<B2DynamicTreeNode> = new Array<B2DynamicTreeNode>();
        
        var count : Int = 0;
        stack[count++] = m_root;
        
        while (count > 0)
        {
            var node : B2DynamicTreeNode = stack[--count];
            
            if (node.aabb.TestOverlap(segmentAABB) == false)
            {
                continue;
            }
            
            // Separating axis for segment (Gino, p80)
            // |dot(v, p1 - c)| > dot(|v|,h)
            
            var c : B2Vec2 = node.aabb.GetCenter();
            var h : B2Vec2 = node.aabb.GetExtents();
            var separation : Float = Math.abs(v.x * (p1.x - c.x) + v.y * (p1.y - c.y))
            - abs_v.x * h.x
            - abs_v.y * h.y;
            if (separation > 0.0)
            {
                continue;
            }
            
            if (node.IsLeaf())
            {
                var subInput : B2RayCastInput = new B2RayCastInput();
                subInput.p1 = input.p1;
                subInput.p2 = input.p2;
                subInput.maxFraction = input.maxFraction;
                
                maxFraction = callback(subInput, node);
                
                if (maxFraction == 0.0)
                {
                    return;
                }
                
                //Update the segment bounding box
                {
                    tX = p1.x + maxFraction * (p2.x - p1.x);
                    tY = p1.y + maxFraction * (p2.y - p1.y);
                    segmentAABB.lowerBound.x = Math.min(p1.x, tX);
                    segmentAABB.lowerBound.y = Math.min(p1.y, tY);
                    segmentAABB.upperBound.x = Math.max(p1.x, tX);
                    segmentAABB.upperBound.y = Math.max(p1.y, tY);
                }
            }
            // No stack limit, so no assert
            else
            {
                
                stack[count++] = node.child1;
                stack[count++] = node.child2;
            }
        }
    }
    
    
    private function AllocateNode() : B2DynamicTreeNode
    // Peel a node off the free list
    {
        
        if (m_freeList)
        {
            var node : B2DynamicTreeNode = m_freeList;
            m_freeList = node.parent;
            node.parent = null;
            node.child1 = null;
            node.child2 = null;
            return node;
        }
        
        // Ignore length pool expansion and relocation found in the C++
        // As we are using heap allocation
        return new B2DynamicTreeNode();
    }
    
    private function FreeNode(node : B2DynamicTreeNode) : Void
    {
        node.parent = m_freeList;
        m_freeList = node;
    }
    
    private function InsertLeaf(leaf : B2DynamicTreeNode) : Void
    {
        ++m_insertionCount;
        
        if (m_root == null)
        {
            m_root = leaf;
            m_root.parent = null;
            return;
        }
        
        var center : B2Vec2 = leaf.aabb.GetCenter();
        var sibling : B2DynamicTreeNode = m_root;
        if (sibling.IsLeaf() == false)
        {
            do
            {
                var child1 : B2DynamicTreeNode = sibling.child1;
                var child2 : B2DynamicTreeNode = sibling.child2;
                
                //b2Vec2 delta1 = b2Abs(m_nodes[child1].aabb.GetCenter() - center);
                //b2Vec2 delta2 = b2Abs(m_nodes[child2].aabb.GetCenter() - center);
                //float32 norm1 = delta1.x + delta1.y;
                //float32 norm2 = delta2.x + delta2.y;
                
                var norm1 : Float = Math.abs((child1.aabb.lowerBound.x + child1.aabb.upperBound.x) / 2 - center.x)
                + Math.abs((child1.aabb.lowerBound.y + child1.aabb.upperBound.y) / 2 - center.y);
                var norm2 : Float = Math.abs((child2.aabb.lowerBound.x + child2.aabb.upperBound.x) / 2 - center.x)
                + Math.abs((child2.aabb.lowerBound.y + child2.aabb.upperBound.y) / 2 - center.y);
                
                if (norm1 < norm2)
                {
                    sibling = child1;
                }
                else
                {
                    sibling = child2;
                }
            }
            while ((sibling.IsLeaf() == false));
        }
        
        // Create a parent for the siblings
        var node1 : B2DynamicTreeNode = sibling.parent;
        var node2 : B2DynamicTreeNode = AllocateNode();
        node2.parent = node1;
        node2.userData = null;
        node2.aabb.Combine(leaf.aabb, sibling.aabb);
        if (node1 != null)
        {
            if (sibling.parent.child1 == sibling)
            {
                node1.child1 = node2;
            }
            else
            {
                node1.child2 = node2;
            }
            
            node2.child1 = sibling;
            node2.child2 = leaf;
            sibling.parent = node2;
            leaf.parent = node2;
            do
            {
                if (node1.aabb.Contains(node2.aabb))
                {
                    break;
                }
                
                node1.aabb.Combine(node1.child1.aabb, node1.child2.aabb);
                node2 = node1;
                node1 = node1.parent;
            }
            while ((node1));
        }
        else
        {
            node2.child1 = sibling;
            node2.child2 = leaf;
            sibling.parent = node2;
            leaf.parent = node2;
            m_root = node2;
        }
    }
    
    private function RemoveLeaf(leaf : B2DynamicTreeNode) : Void
    {
        if (leaf == m_root)
        {
            m_root = null;
            return;
        }
        
        var node2 : B2DynamicTreeNode = leaf.parent;
        var node1 : B2DynamicTreeNode = node2.parent;
        var sibling : B2DynamicTreeNode;
        if (node2.child1 == leaf)
        {
            sibling = node2.child2;
        }
        else
        {
            sibling = node2.child1;
        }
        
        if (node1 != null)
        
        // Destroy node2 and connect node1 to sibling{
            
            if (node1.child1 == node2)
            {
                node1.child1 = sibling;
            }
            else
            {
                node1.child2 = sibling;
            }
            sibling.parent = node1;
            cast((node2), FreeNode);
            
            // Adjust the ancestor bounds
            while (node1)
            {
                var oldAABB : B2AABB = node1.aabb;
                node1.aabb = b2AABB.Combine(node1.child1.aabb, node1.child2.aabb);
                
                if (oldAABB.Contains(node1.aabb))
                {
                    break;
                }
                
                node1 = node1.parent;
            }
        }
        else
        {
            m_root = sibling;
            sibling.parent = null;
            cast((node2), FreeNode);
        }
    }
    
    private var m_root : B2DynamicTreeNode;
    private var m_freeList : B2DynamicTreeNode;
    
    /** This is used for incrementally traverse the tree for rebalancing */
    private var m_path : Int;
    
    private var m_insertionCount : Int;
}

