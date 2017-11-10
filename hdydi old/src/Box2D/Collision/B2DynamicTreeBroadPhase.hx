package box2D.collision;

import haxe.Constraints.Function;
import box2D.common.math.*;

/**
 * The broad-phase is used for computing pairs and performing volume queries and ray casts.
 * This broad-phase does not persist pairs. Instead, this reports potentially new pairs.
 * It is up to the client to consume the new pairs and to track subsequent overlap.
 */
class B2DynamicTreeBroadPhase implements IBroadPhase
{
    /**
	 * Create a proxy with an initial AABB. Pairs are not reported until
	 * UpdatePairs is called.
	 */
    public function CreateProxy(aabb : B2AABB, userData : Dynamic) : Dynamic
    {
        var proxy : B2DynamicTreeNode = m_tree.CreateProxy(aabb, userData);
        ++m_proxyCount;
        cast((proxy), BufferMove);
        return proxy;
    }
    
    /**
	 * Destroy a proxy. It is up to the client to remove any pairs.
	 */
    public function DestroyProxy(proxy : Dynamic) : Void
    {
        cast((proxy), UnBufferMove);
        --m_proxyCount;
        m_tree.DestroyProxy(proxy);
    }
    
    /**
	 * Call MoveProxy as many times as you like, then when you are done
	 * call UpdatePairs to finalized the proxy pairs (for your time step).
	 */
    public function MoveProxy(proxy : Dynamic, aabb : B2AABB, displacement : B2Vec2) : Void
    {
        var buffer : Bool = m_tree.MoveProxy(proxy, aabb, displacement);
        if (buffer)
        {
            cast((proxy), BufferMove);
        }
    }
    
    public function TestOverlap(proxyA : Dynamic, proxyB : Dynamic) : Bool
    {
        var aabbA : B2AABB = m_tree.GetFatAABB(proxyA);
        var aabbB : B2AABB = m_tree.GetFatAABB(proxyB);
        return aabbA.TestOverlap(aabbB);
    }
    
    /**
	 * Get user data from a proxy. Returns null if the proxy is invalid.
	 */
    public function GetUserData(proxy : Dynamic) : Dynamic
    {
        return m_tree.GetUserData(proxy);
    }
    
    /**
	 * Get the AABB for a proxy.
	 */
    public function GetFatAABB(proxy : Dynamic) : B2AABB
    {
        return m_tree.GetFatAABB(proxy);
    }
    
    /**
	 * Get the number of proxies.
	 */
    public function GetProxyCount() : Int
    {
        return m_proxyCount;
    }
    
    /**
	 * Update the pairs. This results in pair callbacks. This can only add pairs.
	 */
    public function UpdatePairs(callback : Function) : Void
    {
        m_pairCount = 0;
        // Perform tree queries for all moving queries
        for (queryProxy/* AS3HX WARNING could not determine type for var: queryProxy exp: EIdent(m_moveBuffer) type: null */ in m_moveBuffer)
        
        // We have to query the tree with the fat AABB so that{
            function QueryCallback(proxy : B2DynamicTreeNode) : Bool
            // A proxy cannot form a pair with itself.
            {
                
                if (proxy == queryProxy)
                {
                    return true;
                }
                
                // Grow the pair buffer as needed
                if (m_pairCount == m_pairBuffer.length)
                {
                    m_pairBuffer[m_pairCount] = new B2DynamicTreePair();
                }
                
                var pair : B2DynamicTreePair = m_pairBuffer[m_pairCount];
                pair.proxyA = (proxy < queryProxy) ? proxy : queryProxy;
                pair.proxyB = (proxy >= queryProxy) ? proxy : queryProxy;
                ++m_pairCount;
                
                return true;
            }  // we don't fail to create a pair that may touch later.  ;
            
            
            
            var fatAABB : B2AABB = m_tree.GetFatAABB(queryProxy);
            m_tree.Query(QueryCallback, fatAABB);
        }
        
        // Reset move buffer
        m_moveBuffer.length = 0;
        
        // Sort the pair buffer to expose duplicates.
        // TODO: Something more sensible
        //m_pairBuffer.sort(ComparePairs);
        
        // Send the pair buffer
        var i : Int = 0;
        while (i < m_pairCount)
        {
            var primaryPair : B2DynamicTreePair = m_pairBuffer[i];
            var userDataA : Dynamic = m_tree.GetUserData(primaryPair.proxyA);
            var userDataB : Dynamic = m_tree.GetUserData(primaryPair.proxyB);
            callback(userDataA, userDataB);
            ++i;
            
            // Skip any duplicate pairs
            while (i < m_pairCount)
            {
                var pair : B2DynamicTreePair = m_pairBuffer[i];
                if (pair.proxyA != primaryPair.proxyA || pair.proxyB != primaryPair.proxyB)
                {
                    break;
                }
                ++i;
            }
        }
    }
    
    /**
	 * @inheritDoc
	 */
    public function Query(callback : Function, aabb : B2AABB) : Void
    {
        m_tree.Query(callback, aabb);
    }
    
    /**
	 * @inheritDoc
	 */
    public function RayCast(callback : Function, input : B2RayCastInput) : Void
    {
        m_tree.RayCast(callback, input);
    }
    
    
    public function Validate() : Void
    {  //TODO_BORIS  
        
    }
    
    public function Rebalance(iterations : Int) : Void
    {
        m_tree.Rebalance(iterations);
    }
    
    
    // Private ///////////////
    
    private function BufferMove(proxy : B2DynamicTreeNode) : Void
    {
        m_moveBuffer[m_moveBuffer.length] = proxy;
    }
    
    private function UnBufferMove(proxy : B2DynamicTreeNode) : Void
    {
        var i : Int = m_moveBuffer.indexOf(proxy);
        m_moveBuffer.splice(i, 1);
    }
    
    private function ComparePairs(pair1 : B2DynamicTreePair, pair2 : B2DynamicTreePair) : Int
    //TODO_BORIS:
    {
        
        // We cannot consistently sort objects easily in AS3
        // The caller of this needs replacing with a different method.
        return 0;
    }
    private var m_tree : B2DynamicTree = new B2DynamicTree();
    private var m_proxyCount : Int;
    private var m_moveBuffer : Array<B2DynamicTreeNode> = new Array<B2DynamicTreeNode>();
    
    private var m_pairBuffer : Array<B2DynamicTreePair> = new Array<B2DynamicTreePair>();
    private var m_pairCount : Int = 0;

    public function new()
    {
    }
}

