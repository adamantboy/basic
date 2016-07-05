

PImage img;
HScrollbar hs;
Data[] data=new Data[929];
Table table;
void setup()
{
  size(930,1000);
  
  // img=loadImage("world_map.jpg");
  hs = new HScrollbar(0, 965, width, 30, 30);
  table = loadTable("beijing_air_data_2013_12_2016_5.csv", "header");
  println(table.getRowCount() + " total rows in table"); 
  println(table.getColumnCount() + " total columns in table");
  //导入数据
  int m;m=0;
  for (TableRow row : table.rows()) 
  {
    data[m]=new Data();
    data[m].PM2_5 = row.getFloat("PM2.5");
    data[m].SO2 = row.getFloat("SO2");
    data[m].NO2 = row.getFloat("NO2");
    data[m].Wind_dir = row.getString("Wind_dir");
   // println(data[m].PM2_5+" "+data[m].SO2+" "+data[m].NO2+" "+data[m].Wind_dir);
     m++;
  }
}

void draw()
{
  
  // image(img,0,0);
  
   //滑动块
   hs.update();
   hs.display();
   stroke(0);
   line(0, 930, width, 930);
   line(0, 965, width, 965);
   
   
  
   int C=int(hs.getPos());
   if(C+30>=912)
   {
   C=882;
   }
   fill(255);
   for(int i=0;i<30;i++)
   {
    arc(width/2, width/2, 930,930,radians(-90+i*12), radians(-78+i*12),PIE);
   }
   for(int i=0;i<30;i++)
   {
    fill(int(data[C+i].PM2_5*255/477.5),127,0);
    arc(width/2, width/2,data[C+i].PM2_5*930/477.5,data[C+i].PM2_5*930/477.5,radians(-90+i*12), radians(-78+i*12),PIE);
   }
  // fill(255,0);
  // ellipse(width/2,width/2,930,930);
}


class Data
{
  float PM2_5;
  float SO2;
  float NO2;
  String Wind_dir;
  
  Data()
  {}
}


class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}