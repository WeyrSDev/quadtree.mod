

Function CreateQuadTreeItem:TQuadTreeItem(x:Int, y:Int, w:Int, h:Int)
	Local i:TQuadTreeItem = New TQuadTreeItem
	i.SetPosition(x,y)
	i.SetDimension(w,h)
	Return i
End Function



rem
bbdoc: Item to insert into a quadtree.
end rem
Type TQuadTreeItem Extends TRect

	' object belonging to this item.
	Field _object:Object
	
	'parent node of this item.
	Field _parentNode:TQuadTreeNode
	
	
	Rem
	bbdoc: Set parent node of this item.
	endrem
	Method SetParent(n:TQuadTreeNode)
		_parentNode = n
	End Method
		
	
	rem
	bbdoc: Sets object associated with this quadtree item.
	endrem
	Method SetObject(o:Object)
		_object = o
	End Method
	
	
	rem
	bbdoc: Returns object associated with this quadtree item.
	endrem
	Method GetObject:Object()
		Return _object
	End Method
	
	
	Rem
	bbdoc: Returns bounding box, centered on position.
	Returns: TRect
	endrem
	Method GetBoundingBox:TRect()
		Local r:TRect = New TRect
		r.SetPosition(_position.GetX() - _dimension.GetX() / 2,  ..
				_position.GetY() - _dimension.GetY() / 2)
		r.SetDimension(_dimension.GetX(), _dimension.GetY())
		Return r
	End Method
	
End Type
