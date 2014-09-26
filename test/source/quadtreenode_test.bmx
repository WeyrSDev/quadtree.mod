
'unit tests for TQuadTreeNode

'todo: item movement

rem
Type QuadTreeNodeTest Extends TTest

	Field q:TQuadTreeNode
	
	Method Before() {before}
		q = TQuadTreeNode.Create(-10,-10,20,20, Null)
	End Method
	
	Method After() {after}
		q = Null
	End Method
	
	
	Method Constructor() {test}
		assertNotNull(q)
		assertNotNull(q._itemList)
	End Method
	
	
	Method SetArea() {test}
		q.SetArea(2,5,20,30)
		
		Local r:TRect = q._area
		assertEqualsI(2, r.GetX())
		assertEqualsI(5, r.GetY())
		assertEqualsI(20, r.dimension.GetX())
		assertEqualsI(30, r.dimension.GetY())
	End Method	

	
	Method SetMaxItems() {test}
		q.SetMaxItems(10)
		assertEqualsI(10, q.maxItems)	
	End Method
	
	
	Method Partition() {test}
		q.SetArea(0,0,100,200)
		q.Partition()
		
		'the node should now contain 4 new nodes.
		assertNotNull(q.node[0])
		assertNotNull(q.node[1])
		assertNotNull(q.node[2])
		assertNotNull(q.node[3])
		
		'parents should be set
		assertSame(q, q.node[0].parentNode)
		assertSame(q, q.node[1].parentNode)
		assertSame(q, q.node[2].parentNode)
		assertSame(q, q.node[3].parentNode)
		
		'node 0 should be rect: 0,0,50,100
		Local n0:TQuadTreeNode = q.node[0]
		assertEqualsF(0, n0.area.origin.GetX())
		assertEqualsF(0, n0.area.origin.GetY())
		assertEqualsF(50, n0.area.dimension.GetX())
		assertEqualsF(100, n0.area.dimension.GetY())
		
		'node 1 should be rect: 50,0,50,100
		Local n1:TQuadTreeNode = q.node[1]
		assertEqualsF(50, n1.area.origin.GetX())
		assertEqualsF(0, n1.area.origin.GetY())
		assertEqualsF(50, n1.area.dimension.GetX())
		assertEqualsF(100, n1.area.dimension.GetY())

		'node 2 should be rect: 0,100,50,100
		Local n2:TQuadTreeNode = q.node[2]
		assertEqualsF(0, n2.area.origin.GetX())
		assertEqualsF(100, n2.area.origin.GetY())
		assertEqualsF(50, n2.area.dimension.GetX())
		assertEqualsF(100, n2.area.dimension.GetY())
		
		'node 3 should be rect: 50,100,50,100
		Local n3:TQuadTreeNode = q.node[3]
		assertEqualsF(50, n3.area.origin.GetX())
		assertEqualsF(100, n3.area.origin.GetY())
		assertEqualsF(50, n3.area.dimension.GetX())
		assertEqualsF(100, n3.area.dimension.GetY())
	
	End Method
	
	
	Method InsertItem() {test}
		Local i:TQuadTreeItem = New TQuadTreeItem
		q.InsertItem(i)
		assertTrue(q.itemList.Contains(i))
		
		'parent should have been set in item
		assertSame(q, i.parentNode)
	End Method
	
		
	Method NotAddSameItemTwice() {test}
		Local i:TQuadTreeItem = New TQuadTreeItem
		q.InsertItem(i)
		q.InsertItem(i)
		assertEqualsI(1, q.itemList.Count())
	End Method
		
	
	Method AddItemToPartitionedNode() {test}
		q.SetArea(0,0,100,100)
		q.Partition()
		
		Local i:TQuadTreeItem = New TQuadTreeItem
		i.SetPosition(10,60)
		q.InsertItem(i)

		'item should be added to a leaf node, not to this node
		assertFalse(q.itemList.Contains(i))
		'should be in node[2]
		assertTrue(q.node[2].itemlist.Contains(i))		
	End Method
	
	
	Method MoveItem() {test}
	
		q.SetArea(-50,-50, 100,100)
		q.Partition()
		
		Local i:TQuadTreeItem = New TQuadTreeItem
		i.SetPosition(10,10)
		q.InsertItem(i)
		
		'should be in node[3]
		assertTrue(q.node[3].itemlist.Contains(i), "not in node 3")	
		
		'lets modify item position up and then move it.
		i.SetPosition(10,-10)
		q.node[3].MoveItem(i)
		
		'should now be in node[1] (topright)
		assertTrue(q.node[1].itemlist.Contains(i), "not in node 1")
	End Method
		
End Type

endrem