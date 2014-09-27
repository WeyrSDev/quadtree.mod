Intro
-------------------------------------------------------------------------------

This Blitzmax module allows the creation of quadtrees, nodes and items. Items in the tree can be quickly found by using simple rectangle overlap checks, which is ideal for collision checks or camera viewports in large scrolling areas.

A QuadTree covers a rectangular area. TreeNodes partition this area and these nodes can also be partitioned. A TreeNode contains the TreeNodeItems which fit into the node area.

![quadtree](https://dl.dropboxusercontent.com/u/12644619/pics/dev/quadTree01.jpg)

A node will subdivide itself into four new nodes when the amount of items in the node exceeds a certain amount (the default in the module is 50) and its items will be distributed over these new child nodes.

Documentation
-------------------------------------------------------------------------------

Documentation is currently viewable on the [project's wiki](http://wiki.github.com/wiebow/quadtree.mod/).

Installation
-------------------------------------------------------------------------------

All my modules must be put in a subfolder of `Blitzmax/mod/wdw.mod`.
To install this module, put the `quadtree.mod` folder in `Blitzmax/mod/wdw.mod`. You can do this in the following ways:

1. Clone the repository into your `BlitzMax/mod/wdw.mod` directory using `git clone git://github.com/wiebow/quadtree.mod.git`
2. Click the 'Download Source' button at the top of the Source section of the GitHub repository and extract this into your `BlitzMax/mod/wdw.mod` directory.

After this, simply run `bmk makemods wdw.quadtree` or rebuild the module from your IDE.

Types
-------------------------------------------------------------------------------

The module consists of the following types:

 * *TQuadTree* : Overall manager.
 * *TQuadTreeNode* : a tree node which can be partitioned into 4 sections.
 * *TQuadTreeItem* : an item containing positional and area (bounding box) information.
 * *TRect* : all areas are defined by a TRect, includes contain and overlap methods.

How to use
-------------------------------------------------------------------------------

It is best to create a tree with the correct area size before adding all objects. Resizing the world is done automatically but is a costly operation when the tree already holds a lot of nodes and items.
Create a quadtree, covering an area of 0,0 to 200,200. A node can contain 10 items before it splits itself up.

Here is an example:

    Import wdw.quadtree
    q:TQuadTree = CreateQuadTree(10, 0,0, 200,200)

Create an item, and add it to the tree. The item has a bounding box of 20 by 20.

    Local i:TQuadTreeItem = CreateQuadTreeItem(0,0, 20,20)
    q.InsertItem(i)

The item is now located in the tree. It can be retrieved by using the GetItems() methods and a TRect defining the area from which you want to retrieve items.

    Local l:TList = q.GetItems( CreateTRect(0,0,100,100) )
    Print l.Count()

The list will be empty when the rect you define does not overlap the item bounding box. The bounding box is centred around the item position by default.

    Local l:TList = q.GetItems( CreateTRect(100,0,100,100) )
    Print l.Count()

Up until now the tree consists of one node as the item we added fitted in the defined area and item count has not exceeded the node limit. There was no need to resize the world area or split up the root node. Let's do that now by creating 50 random items which can be outside the world area:

    For Local c:Int = 0 to 50
        q.InsertItem( CreateQuadTreeItem( Rnd(300), Rnd(300), 20,20) )
    Next

License
-------------------------------------------------------------------------------

Quadtree is licensed under the MIT license:

    Copyright (c) 2014 Wiebo de Wit.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
