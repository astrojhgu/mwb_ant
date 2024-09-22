$fn = 50;
arm_height = 400;
dipole_l = 740;

nut_d = 110;
nut_h = 150;
arm_depth = 35;
arm_thickness = 10;
arm_pole_w = 15;
arm_root_h = 100;
amp_chamber_d = 36;
arm_hole_x = 40;
arm_hole_h = 30;
arm_hole_d = 6.5;
nut_cable_hole_d = 45;
arm_bolt_l = 45;
arm_bolt_plane_d = 22;
sma_hole_d = 12;
sma_hole_r = 11;

foot_pole_d_out=15;
foot_pole_d_in=6.5;
foot_plate_h=80;
foot_plate_w=60;
foot_plate_t=4;


tana = (arm_height / 2 / (dipole_l / 2 - arm_pole_w));
cosa = 1.0/sqrt(1.0+tana*tana);
sina = tana/sqrt(1.0+tana*tana);
arm_half_angle = atan(tana);

echo("sina=",sina);
echo("cosa=",cosa);
echo(sina*sina+cosa*cosa);

echo(arm_half_angle);

lid_thickness = 5;
lid_depth = 15;
amp_eff_d = 36;
amp_key_w = 6.5;
amp_key_h = 6.5;
foot_h = 75;
foot_h1 = 75;
foot_l1 = 65;

amp_branch_wide = 6;
amp_branch_dw = 1;

square_nut_a = 16;
square_nut_t = 3.5;
square_nut_h1 = 10;

// #import("arm.stl");
// #import("nut_v3.stl");
module nut_16()
{

	difference()
	{
		linear_extrude(nut_h / 2) difference()
		{
			circle(d = nut_d);
			circle(d = amp_chamber_d);
			polygon([
				[ 0, 0 ],
				[ nut_d / 2 - arm_depth, 0 ],
				[ nut_d / 2 - arm_depth, arm_thickness / 2 ],
				[ nut_d, arm_thickness / 2 ],
				[ nut_d, -nut_d ],
				[ -nut_d, -nut_d ],
				[ -nut_d, nut_d ],
				[ nut_d, nut_d ],
			]);
			rotate([ 0, 0, 45 ])
			translate([ 0, -amp_key_w / 2, 0 ])
			square([ amp_chamber_d / 2 + amp_key_h, amp_key_w ]);
		}

		translate([ 0, -(amp_branch_wide + amp_branch_dw) / 2, arm_root_h / 2 ])
		cube([ nut_d, amp_branch_wide + amp_branch_dw, nut_h / 2 ]);

		translate([ arm_hole_x, 0, arm_hole_h ])
		rotate([ -90, 0, 0 ])
		{
			cylinder(d = arm_hole_d, h = nut_d);
			translate([ 0, 0, arm_bolt_l / 2 ])
			cylinder(d = arm_bolt_plane_d, h = nut_d);
		}

		translate([ nut_d / 2 - arm_depth, -square_nut_a / 2, arm_root_h / 2 + square_nut_h1 ])
		{
			cube([ arm_depth, square_nut_a, square_nut_t ]);
		}
	}
}

module nut_8()
{
	difference()
	{
		union()
		{
			nut_16();
			mirror([ -1, 1, 0 ]) nut_16();
		}
	}
}

module nut_4()
{
	union()
	{
		nut_8();
		rotate(180, [ 1, 1, 0 ])
		nut_8();
	}
}

module arm_upper()
{
	x1 = (arm_root_h / 2 - 2) / tana;
	x0 = arm_pole_w / sin(arm_half_angle);

	rotate([ 90, 0, 0 ])
	linear_extrude(arm_thickness, center = true)
	{
		difference()
		{
			polygon([
				[ nut_d / 2 - arm_depth, 0 ],
				[ nut_d / 2 - arm_depth, arm_root_h / 2 ],
				[ nut_d / 2, arm_root_h / 2 ],
				[ nut_d / 2, arm_root_h / 2 - 2 ],
				[ x1, arm_root_h / 2 - 2 ],
				[ dipole_l / 2 - arm_pole_w, arm_height / 2 ],
				[ dipole_l / 2, arm_height / 2 ],
				[ dipole_l / 2, 0 ],
			]);
			polygon([[x1, arm_pole_w / 2], [x1, (x1 - x0) * tana],
			         [dipole_l / 2 - arm_pole_w, (dipole_l / 2 - arm_pole_w - x0) * tana],
			         [dipole_l / 2 - arm_pole_w, arm_pole_w / 2]]);

			translate([ arm_hole_x, arm_hole_h, 0 ])
			circle(d = arm_hole_d);
		}
	}
}

module arm()
{
	union()
	{
		arm_upper();
		mirror([ 0, 0, 1 ]) arm_upper();
	}
}

module square_nut()
{
	difference()
	{
		translate([ -square_nut_a / 2, -square_nut_a / 2, 0 ])
		cube([ square_nut_a, square_nut_a, square_nut_t ]);
		cylinder(h = 50, d = 6);
	}
}

module foot(){
	x0 = arm_pole_w / sin(arm_half_angle);
	h=foot_pole_d_out/2/tan((90.0-arm_half_angle)/2.0);
	hole_venters=[
		[dipole_l/2-arm_pole_w-foot_pole_d_out/2,0,-(dipole_l / 2 - arm_pole_w - x0) * tana+h],
		[dipole_l/2-arm_pole_w-foot_pole_d_out/2-(foot_pole_d_out+arm_pole_w)*sin(arm_half_angle),0,-(dipole_l / 2 - arm_pole_w - x0) * tana+h-(foot_pole_d_out+arm_pole_w)*cos(arm_half_angle)],
		[dipole_l/2+foot_pole_d_out/2,0,-(dipole_l / 2 - arm_pole_w - x0) * tana+h],
		[dipole_l/2-arm_pole_w/2,0,-arm_height/2-foot_pole_d_out/2],
	];

	hole_x=[for(v=hole_venters)v[0]];
	hole_z=[for(v=hole_venters)v[2]];
	hole_x_min=min(hole_x);
	hole_x_max=max(hole_x);
	hole_z_min=min(hole_z);
	hole_z_max=max(hole_z);
	plate_x=(hole_x_max+hole_x_min)/2;
	plate_z=(hole_z_max+hole_z_min)/2;


	difference(){
		for(i=[-1,1]){
			translate([plate_x, i*(arm_thickness/2+foot_plate_t/2), plate_z])
			cube([foot_plate_w,foot_plate_t, foot_plate_h],center=true);
		}

		for(v=hole_venters){
			translate(v){
				rotate([90,0,0]){
					difference(){
						#cylinder(h=arm_thickness+2*foot_plate_t, d=foot_pole_d_in,center=true);
					}
				}
			}
		}
	}

	for(v=hole_venters){
		translate(v){
			rotate([90,0,0]){
				difference(){
					cylinder(h=arm_thickness, d=foot_pole_d_out,center=true);
					#cylinder(h=arm_thickness, d=foot_pole_d_in,center=true);
				}
			}
		}
	}

	
}

module lna()
{
	union()
	{
		cylinder(d = 35, h = 2);

		for (i = [ 0, 1, 2, 3 ])
		{
			rotate([ 0, 0, i * 90 ])
			union()
			{
				translate([ 0, -6.5/2, 0 ])
				cube([ 24.74, 6.5, 2 ]);
				translate([ 56/2, 0, 0 ])
				difference()
				{
					cylinder(d = 9.2, h = 2);
					cylinder(d = 4, h = 2);
				}
			}
		}
	}
}


translate([0,0, arm_root_h/2])
#lna();

for (i = [ 0, 1, 2, 3 ])
{
	rotate([ 0, 0, 90 * i ])
	translate([ nut_d / 2 - arm_depth + square_nut_a / 2, 0, arm_root_h / 2 + square_nut_h1 ])
	square_nut();
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
		nut_4();
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
