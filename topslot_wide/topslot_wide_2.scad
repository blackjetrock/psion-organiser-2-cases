// Psion Organiser top slot case part
//

// Render the box or the lid
box = 1;
lid = 0;

z_h = 6.7;
z_cut = 5.9;

box_x = 78;
box_y = 40;
box_z = 30;
box_shift = 12;

tongue_shift_z = -3;
tongue_shift_x = -6; 
th = 2.5;
pillar_r = 2;

screw_h_r = 1.5-box*0.6;

pcb_runner_th = 2;

// Pillars for lid screws
module screw_pillar()
{
    difference()
    {
      rotate([90, 0, 0])
      cylinder(r=pillar_r+0.51, h= box_y, center=true, $fn=100);  
    }
}

countersunk = 0;

module screw_hole()
{
    rotate([90, 0, 0])
    cylinder(r=screw_h_r, h= box_y-th*2, center=true, $fn=100);  

    if( countersunk )
    {
        translate([0, box_y/2-th*2.7+th+1.4, 0])
        rotate([90, 0, 0])
        cylinder(r2=screw_h_r, r1=screw_h_r*1.5, h = th*2.1, center=true, $fn=100);  
    }
    else
    {
        translate([0, box_y/2-th*2.7+th+1.4, 0])
        rotate([90, 0, 0])
        cylinder(r2=screw_h_r, r1=screw_h_r*1.0, h = th*2.5, center=true, $fn=100);  
    }
}

pillar_shift_x_upper = 3;
pillar_shift_x_lower = 12.0;

pillar_shift_z = 2;


psx_u = pillar_shift_x_upper;
psx_l = pillar_shift_x_lower;

psz = pillar_shift_z;

module screw_pillars()
{
    
  translate([-box_x/2+pillar_r+psx_l, box_y/2+box_shift, -box_z/2+pillar_r+psz])
  screw_pillar();

  translate([ box_x/2-pillar_r-psx_l, box_y/2+box_shift, -box_z/2+pillar_r+psz])
  screw_pillar();

  translate([ box_x/2-pillar_r-psx_u, box_y/2+box_shift,  box_z/2-pillar_r-psz])
  screw_pillar();

  translate([-box_x/2+pillar_r+psx_u, box_y/2+box_shift,  box_z/2-pillar_r-psz])
  screw_pillar();

}

module screw_holes()
{
  translate([-box_x/2+pillar_r+psx_l, box_y/2+box_shift, -box_z/2+pillar_r+psz])
  screw_hole();

  translate([ box_x/2-pillar_r-psx_l, box_y/2+box_shift, -box_z/2+pillar_r+psz])
  screw_hole();

  translate([ box_x/2-pillar_r-psx_u, box_y/2+box_shift,  box_z/2-pillar_r-psz])
  screw_hole();

  translate([-box_x/2+pillar_r+psx_u, box_y/2+box_shift,  box_z/2-pillar_r-psz])
  screw_hole();

}

module rounded_cuboid(x, y, z, rd)
{
  scale([1, 0.5, 1])
  translate([-x/2, 0, -z/2])
  minkowski()
    {  
    cube([x-rd-rd, y, z-rd-rd], center=true);
    translate([x/2, 0, z/2])
        rotate([90,0,0])
      cylinder(h=y, r=rd, $fn=100, center=true);
    }
}

module truncated_cuboid(x, y, z, angle, z_height)
{
difference()
    {
        cube([x, y, z], center=true);
        
        cube([2*x, 2*y, z], center=true);
        
    }
}

module box_prism(x, y, z, x_h, z_h)
{
translate([0, y/2, 0])
rotate([90, 0, 0])
linear_extrude(y) 
  {
  polygon(
    points = 
      [
      [-x/2,      z/2],
      [ x/2,      z/2],
      [ x/2,     -z/2+z_h],
      [ x/2-x_h, -z/2],
      [-x/2+x_h, -z/2],
      [-x/2,     -z/2+z_h]
      ]
      );
  }
 }

 
module rounded_truncated_cuboid(x, y, z, rd)
{
  scale([1, 0.5, 1])
  translate([-x/2, 0, -z/2])
  minkowski()
    {  
        
    //cube([x-rd-rd, y, z-rd-rd], center=true);
    box_prism(x-rd-rd, y, z-rd-rd, 7, 3.5);    
        
    translate([x/2, 0, z/2])
        rotate([90,0,0])
      cylinder(h=y, r=rd, $fn=100, center=true);
    }
}

module lid_gasket()
 {
     if(0)
     {
     translate([0, 0, -box_z/2])
     cube([1,1,1], center=true);
     }
     
 difference()
     {
         rounded_truncated_cuboid(box_x-th, th/2, box_z-th, 4);
         rounded_truncated_cuboid(box_x-th*2, th/2+0.01, box_z-th*2, 3);
     }
 }

module box_gasket()
 {
 difference()
     {
         rounded_truncated_cuboid(box_x, th/2, box_z, 4);
         rounded_truncated_cuboid(box_x-th+0.2, th+0.01, box_z-th+0.2, 3);
     }
 }

if(box)
{
translate([0, box_shift+box_y-th-th*.75, 0])
box_gasket();
}

if(lid)
{
translate([0, box_shift+box_y-th-th*.75-1, 0])
lid_gasket();
}


module box_pre()
{
    //cube([box_x, box_y,  box_z], center=true);
    rounded_truncated_cuboid(box_x, box_y, box_z, 4);
}

if(0)
{
translate([0, -100, 0])
{
    %cube([box_x, box_y,  box_z], center=true);
    rounded_truncated_cuboid(box_x, box_y, box_z, 4);
}
}

module box_rem()
{
   //cube([box_x-2*th, box_y-2*th,  box_z-2*th], center=true);
   rounded_truncated_cuboid(box_x-2*th, box_y-2*th, box_z-2*th, 3);
    
   screw_holes();        
}

module box()
{
   difference()
    {
        box_pre();
        box_rem();
    }
}

module pcb_runner()
{
    difference()
    {
       cube([pcb_runner_th, box_y, pcb_runner_th*3], center=true);
       cube([pcb_runner_th+0.1, box_y, pcb_runner_th], center=true);
    }

}


module pre()
{

    screw_pillars();
    translate([0, box_y/2+box_shift, 0])

    box();
    
    
    translate([tongue_shift_x, 0, tongue_shift_z])
    {   
        // -----   Tongue
        cube([23.5, 24.5, z_h], center=true);
    
        translate([0, 0, (z_h+1.1)/2])
        cube([1.3, 24.5, 1.1], center=true);
    
        translate([-23.5/2-1.3/2, 0, -z_h/2+1.1/2+1.4])
        cube([1.3, 24.5, 1.1], center=true);
    
        translate([23.5/2+1.3/2, 0, -z_h/2+1.1/2+1.4])
        cube([1.3, 24.5, 1.1], center=true);
        // -----

    }
       
// Mount edges  
    translate([0.45, 11.25, -4.8])
    cube([39, 1.6, 12.5], center=true);
       

    
}

z_cut2 = 8.9;

module rem()
{
    translate([tongue_shift_x, 0, tongue_shift_z])
    {   
        translate([0, 3, -z_h/2+z_cut/2-0.1])
        cube([20.8, 25+6, z_cut+0.1], center=true);
    }

    translate([tongue_shift_x, 10, -z_cut2/2])
    {   
        translate([0, 3, -z_h/2+z_cut/2-0.1])
        cube([20.8, 3.0, z_cut2+0.1], center=true);
    }
    
}


module topslot()
{
    
   difference()
    {
        pre();
        rem();
        difference()
          {
           screw_holes();
           }

    }
        
    // PCB runners  
    translate([0, box_y/2+box_shift, tongue_shift_z])
       {
           translate([box_x/2-pcb_runner_th-th/2, 0, -z_h+pcb_runner_th*1.5])
           pcb_runner();
       }

    translate([0, box_y/2+box_shift, tongue_shift_z])
       {
           translate([-box_x/2+pcb_runner_th+th/2, 0, -z_h+pcb_runner_th*1.5])
           pcb_runner();
       }
       
}


difference()
{
    topslot();
    
    if( box )
    {
    // Chop the top off the box so contents can get in
    translate([0, box_y+box_shift-th+0.1, 0])
    cube([110, th*2, 110], center=true);
    }

    if( lid )
    {
    // Chop the box off so we get the lid
    translate([0, -100+box_y+box_shift-th*2+0.1, 0])
    cube([120, 200, 120], center=true);
    }
    
}


// PCB test
//translate([0,40, 0])
//cube([72, 37, 1.6],center=true);

//translate([0,30,00])
//cube([1,1,1], center=true);
