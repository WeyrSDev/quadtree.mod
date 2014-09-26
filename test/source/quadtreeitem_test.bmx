

'unit tests for TQuadTreeItem

Type TQuadTreeItemTest Extends TTest

	Field i:Tquadtreeitem
	
		
	Method Before() {before}
		i = CreateQuadTreeItem(0, 0, 200, 100)
	End Method
	
	Method After() {after}
		i = Null		
	End Method
	
	
	Method Constructor() {test}
		assertNotNull(i)
		assertNotNull(i._position)
		assertNotNull(i._dimension)
	End Method
	
	
	Method GetAndSetPosition() {test}
		i.SetPosition(5,50)
		Local p:TVector2D = i.GetPosition()	
		
		assertEqualsF(5, p.GetX())
		assertEqualsF(50, p.GetY())
	End Method
	
	
	Method GetBoundingBox() {test}
		'should be -100,-50, 200, 100
		'centered around position.
		Local r:TRect = i.GetBoundingBox()
		assertEqualsF(-100, r.GetX())
		assertEqualsF(-50, r.GetY())
		assertEqualsF(200, r.GetWidth())
		assertEqualsF(100, r.GetHeight())
	End Method

End Type
