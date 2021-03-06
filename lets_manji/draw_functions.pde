void draw_start_menu()
{
  PFont font = createFont("MS PGothic",150,true);
  textFont(font);
  textSize(150);
  fill(255, 250, 100);
  text("Let's 卍", width/3, height/4);
  textSize(50);
  imageMode(CENTER);
  image(loadImage("start_menu.jpg"), width/2, height*3/5);
  image(loadImage("school_furyou_tsuppari.png"), width*6/7, height/4);
  imageMode(CORNER);
}

void draw_time_gage()
{  
  fill(200);
  rect(width/4, height/20, width/2, height/20);
  fill(255, 0, 0);
  float rate = (float)unit_timer.duration() / (float)unit_timer.time_limit;
  rect(width/4, height/20, (width/2)*(1 - rate), height/20);
}

void draw_background() {
  fill(0, 185, 0);
  rect(0, height/5, width, height);
  fill(195, 146, 121);
  triangle(width/2, height/10, 0, height, width, height);
  fill(100, 150, 255);
  rect(0, 0, width, height/5);
}

void draw_game_time()
{
  fill(0);
  textSize(48);
  text("残り時間 : " + (game_timer.time_limit - game_timer.duration())/1000 + " [s]", width-375, 180);
}

//image_position_test
void draw_max_canvas() {
  fill(255);
  rect((width - image_canvas_scale)/2, height*3/10, image_canvas_scale, image_canvas_scale);
}

class ResultDisplay
{
  final int correct     = 0;
  final int incorrect   = 1;
  final int timeup      = 2;
  final int finish      = 3;
  final int good_finish = 4;
  final int bad_finish  = 5;

  int mode;
  Timer timer;
  boolean is_active;

  ResultDisplay(int limit)
  {
    timer = new Timer(limit);
    is_active = false;
  }

  void activate(int m)
  {
    mode = m;
    timer.reset();
    is_active = true;
    gesture_socket.lock();
  }

  void display()
  {
    timer.update();
    switch (mode)
    {
    case correct:
      display_correct();
      break;
    case incorrect:
      display_incorrect();
      break;
    case timeup:
      display_timeup();
      break;
    case finish:
      display_finish();
      break;
    case good_finish:
      display_good_finish();
      break;
    case bad_finish:
      display_bad_finish();
    }
    if (timer.should_reset())
    {
      is_active = false;
      unit_timer.reset();
      gesture_socket.release();
    }
  }

  void display_correct()
  {
    background(0, 0, 0, 250);
    textSize(120);
    text("正解！！", width/4, 200);
    show_answer();
  }

  void display_incorrect()
  {
    background(0, 0, 0, 200);
    textSize(120);
    text("ちがうよ！！", width/4, 200);
    show_answer();
  }

  void display_timeup()
  {
    background(0, 0, 0, 200);
    textSize(120);
    text("時間切れ！！", width/4, 200);
    show_answer();
  }

  void display_good_finish()
  {
    background(0, 255, 255, 200);
    textSize(68);
    image(loadImage("happy.png"), 0, 0, width, height + height/5);
   }

  void display_finish()
  {
    background(0, 255, 255, 200);
    textSize(120);
    fill(240, 30, 60);
    text("終了！！！ \n " + "得点 : " +  score_board.get(), width/3,height*7/13 );
  }

  void display_bad_finish()
  {
    background(255, 255, 0, 200);
    image(loadImage("bad.png"), 0, 0, width, height + height/5);
  }

  boolean is_active()
  {
    return is_active;
  }
}

void draw_hand()
{
  for (Hand hand : leap.getHands())
  {
    for (Finger finger : hand.getFingers())
    {
      finger.drawBones();
      fill(255, 0, 0);
      finger.drawJoints(20);
    }
  }
  PVector right_hand_pos = get_right_hand_pos();
  fill(0, 200, 0);
  ellipse(right_hand_pos.x, right_hand_pos.y, 25, 25);
}
