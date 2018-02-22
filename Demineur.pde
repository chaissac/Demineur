int[][] grille;
int cote, taille;
boolean over;
void setup() {
  size(400, 400);
  init(8);
}
void init(int t) {
  int a, b;
  over=false;
  taille = t;
  cote=min((width-20)/taille, (height-20)/taille);
  grille=new int[taille][taille];
  for (int i=0; i<taille*taille/6; i++) {
    do {
      a=int(random(taille));
      b=int(random(taille));
    } while (get(a, b)!=0);
    grille[a][b]=-1;
  }
  for (int j=0; j<taille; j++)
    for (int i=0; i<taille; i++)
      if (get(i, j)==0) 
        for (int x=-1; x<2; x++)
          for (int y=-1; y<2; y++)
            if (get(i+x, j+y)==-1) grille[i][j]++;
}
int get(int x, int y) {
  return (x>=0 && x<taille && y>=0 && y<taille)?grille[x][y]:-2;
}
void mousePressed() {
  if (!over) {
    int x=(mouseX-10)/cote;
    int y=(mouseY-10)/cote;
    int g=get(x, y)%10;
    if (g>-2) {
      if (mouseButton==LEFT) {    
        if (g>0 && g<9) grille[x][y]=10+g;
        if (g==0) flood(x, y);
        if (g==-1 || g==9) {
          grille[x][y]=-2;
          over=true;
        }
      } else {
        if (get(x, y)>20) grille[x][y]=g-100;
        else if (g<10) grille[x][y]=g+100;
      }
    }
  } else init(taille);
}
void flood(int i, int j) {
  for (int x=-1; x<2; x++)
    for (int y=-1; y<2; y++)
      if (get(i+x, j+y)%100>=0 && get(i+x, j+y)%100<9) {
        grille[i+x][j+y]=get(i+x, j+y)%10+10;
        if (get(i+x, j+y)==10) flood(i+x, j+y);
      }
}
void draw() {
  background(255);
  textSize(cote/2);
  textAlign(CENTER);
  if (!over) {
    for (int j=0; j<taille; j++)
      for (int i=0; i<taille; i++) {
        int g = get(i, j);
        stroke(0);
        fill((g<10 || g>20)?180:255);
        rect(10+i*cote, 10+j*cote, cote, cote);
        if (g>10 && g<20) {
          fill(0);
          text(g%10, 10+i*cote+cote/2, 10+j*cote+cote/1.5);
        } else if (g>20) {
          noStroke();
          fill(#E00000);
          ellipse(10+i*cote+cote/2, 10+j*cote+cote/2, cote/1.5, cote/1.5);
          fill(#FFFFFF);
          text("?", 10+i*cote+cote/2, 10+j*cote+cote/1.5);
        }
      }
  } else for (int j=0; j<taille; j++)
    for (int i=0; i<taille; i++) {
      int g = get(i, j)%10;
      stroke(0);
      fill(255);
      rect(10+i*cote, 10+j*cote, cote, cote);
      if (g==-2) {
        fill(#F00000);
        rect(10+i*cote, 10+j*cote, cote, cote);
      }
      if (g<0 || g==9) {
        fill(0);
        ellipse(10+i*cote+cote/2, 10+j*cote+cote/2, cote/2, cote/2);
      }
      if (g>0 && g<9) {
        fill(0);
        text(g, 10+i*cote+cote/2, 10+j*cote+cote/1.5);
      }
    }
}