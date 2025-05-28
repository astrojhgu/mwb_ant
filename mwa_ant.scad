include <common.scad>
translate([0,0, arm_root_h/2])
#lna();

for (i = [ 0, 1, 2, 3 ])
{
	rotate([ 0, 0, 90 * i ])
	translate([ nut_d / 2 - arm_depth + square_nut_a / 2, 0, arm_root_h / 2 + square_nut_h1 ])
	color(c=[0,0,1],alpha=0.5)square_nut();
}

for (i = [ 0, 1, 2, 3 ])
{
	rotate([ 0, 0, 90 * i ])
	{
//		nut_4();
		arm();
	}
}

for (i = [0, 1, 2, 3]){
	rotate([0,0,90*i]){
		foot();
	}
}

for (i = [ 0, 1, 2, 3 ])
{
	rotate([ 0, 0, 90 * i ])
	{
		color(c=[0,1,0], alpha=0.5)nut_4();
//		arm();
	}
}

/*
nut_4();
arm();

rotate([0,0,90])
nut_4();

rotate([0,0,90])
arm();
*/

//for feed
if (false){
	union()
	{
		rotate([ 90, 0, 0 ])
		cylinder(h = nut_d / 2 - arm_depth, d = arm_thickness);
		rotate([ -90, 0, 0 ])
		cylinder(h = nut_d / 2 - arm_depth, d = arm_thickness);
	}
}
