# Polygons

This is a very small project I built for an interview preparation.

##### Changing number of sides of a polygon

![Polygon number of sides](https://github.com/mulukengm/Polygons/blob/master/single_polygon.gif)

##### Rotating mutiple polygons

![Polygons rotation](https://github.com/mulukengm/Polygons/blob/master/multiple_polygons.gif)

##### Polygon Definition:
A plane figure with at least three straight sides and angles, and typically five or more.

##### Regular Polygon Definition:
In Euclidean geometry, a regular polygon is a polygon that is equiangular
(all angles are equal in measure) and equilateral (all sides have the same length).
Regular polygons may be convex or star.

##### Simple Polygon Definition:
In geometry a simple polygon is defined as a flat shape consisting of straight,
non-intersecting line segments or "sides" that are joined pair-wise to form a closed path.

It follows from the definitions, and for the sake of this assignment your polygon need only
to be convex and not model any "Star" polygons (that is, your polygon class does not need
to model intersecting itself - hence a Simple Polygon).

========================================================================================================================

### Requirements (Step 1):

+ Use Objective-C
+ Create a SimpleRegularPolygon class that is a subclass of NSObject
+ Class should have a "sides" ivar to hold the number of sides the polygon contains
+ Class should have a "radius" ivar to model the radius in device pts
+ Class should have a sides getter method to get the value of "sides" ivar
+ Class should have a a sides setter method to set the value of the "sides" ivar
+ Class should have a method to return the angle between 2 vertices on the polygon (not the internal vertex angle)

1. The setter method signature should be the following:
- (void)setSides:(NSUInteger)sides error:(NSError **)error;

2. When setting sides set the NSError to return in the case of an invalid argument.

+ Create a method that returns a CGPathRef from the state of the Polygon.
+ Create a UIViewController that uses your SimpleRegularPolygon to draw it's configured shape into a view. 

========================================================================================================================

### Requirements (Step 2):

+ Create a second UIViewController and tile with views that utilize the SimpleRegularPolygon from Step 1
+ Randomly set the number of sides (between 1-8) for each polygon view when tiling.
+ Randomly color your polygon views differently when tiling.
+ Add a method/property to the SimpleRegularPolygon class that allows the CGPathRef to be rotated.
+ Tapping a polygon view should cause it to rotate, along with the directly adjacent views, if present (i.e. above, below, left, and right). Use a delegation pattern when coordinated this.
