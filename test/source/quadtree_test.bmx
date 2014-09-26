
'unit tests for TQuadTree

Type QuadTreeTest Extends TTest

	Field q:TQuadTree	
	
	Method Before() {before}
		q = New TQuadTree
	End Method
	
	Method After() {after}
		q = Null		
	End Method
	
	
	Method Constructor() {test}
		assertNotNull(q)
		assertNotNull(q._area)
		assertNotNull(q._head)
	End Method
	
	
	Method SetMaxItems() {test}
		q.SetMaxItems(10)
		assertEqualsI(10, q._maxItems)
	End Method
	
	
	Method SetArea() {test}		
		q.SetArea(10,20, 30,40)
		
		Local r:TRect = q._area
		assertEqualsF(10, r.GetX())
		assertEqualsF(20, r.GetY())
		assertEqualsF(30, r.GetWidth())
		assertEqualsF(40, r.GetHeight())
	End Method
	
	

	Method ReSizeWorld() {test}	
		'this test only passes if the world has not a 0,0 origin.
		q.SetArea(-100,-100, 200, 200)
		q._head.Partition()
		
		'out of bounds. world should be resized after adding it
		Local i:TQuadTreeItem = CreateQuadTreeItem(300,0, 10,10)
		q.InsertItem(i)
		
		Local r:TRect = q._area
		
		assertEqualsF(-400, r.GetX())
		assertEqualsF(-400, r.GetY())
		
		assertEqualsF(800, r.GetWidth())
		assertEqualsF(800, r.GetHeight())
	End Method
	
	
	
	Method GetAllItems() {test}
		
		'getallitems() walks recursively through all nodes
		'and fills the passed list with items.
	
		q.SetArea(0,0,200,200)
		q._head.Partition()
		
		'add some items to nodes	
		Local i1:TQuadTreeItem = New TQuadTreeItem
		i1.SetPosition(50,50)
		q.InsertItem(i1)
		
		Local i2:TQuadTreeItem = New TQuadTreeItem
		i2.SetPosition(150,50)
		q.InsertItem(i2)
	
		Local i3:TQuadTreeItem = New TQuadTreeItem
		i3.SetPosition(50,150)
		q.InsertItem(i3)
	
		Local l:TList = q.GetAllItems()
		
		'list should contain all items
		assertTrue( l.Contains(i1))
		assertTrue( l.Contains(i2))
		assertTrue( l.Contains(i3))

	End Method
	
End Type
