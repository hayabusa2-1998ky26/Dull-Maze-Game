require 'io/console'

$Japanese = [["\"Dull\"これは迷路ゲームです。", "ゴールはランダムな場所にあります。", "辺りは暗くなっているので、", "近くしか見ることはできません。", "アイテムを駆使して", "ゴールにたどり着きましょう。"], "<操作方法>", "移動　　　　", "決定　　　　", "本当に終了しますか？", "終了しました", "言語 : 日本語", "終了　　　　", "やり直し　　", "キー", "キー", ["<迷路>", "プレイヤー　: \"@\"", "壁　　　　　: \"■\"", "道　　　　　: \" \"", "ゴール　　　: \"\#\"", "アイテム　　: \"+\""], "スクロールできます", ["ゲームを始める", "Dullについて", "設定", "終了する"], ["本当に    ", "終了し    ", "ますか?   "], "はい", "いいえ", ["本当に    ", "やり直し   ", "ますか?   "], "クリア時間 : ", ["秒", "分"], "スペースキーでコンティニュー", ["発見した", ""], "持ち物を見る", "<持ち物>", ["(持ち物 ", "がありま", "せん)   "], [["ゴールへ", "の方角を", "一度だけ", "示してく", "れます"], ["使った場", "所におい", "て進むべ", "き方向を", "一度だけ", "示してく", "れます"], ["50回移動", "するまで", "視界が明", "くなりま", "す。"], ["一度だけ", "壁を無視", "して移動", "できます", "。"]], ["使う", "捨てる", "やめる"], ["使った", "捨てた", "やめた"], ["方向を指", "定してス", "ペースキ", "ーを押し", "てくださ", "い。"]]
$English = [["\"Dull\" This is a maze game where", "you escape from a labyrinth.", "The start is at the top left and", "the goal is at the bottom right.", "It's dark, so you can only", "see up close.", "Use items to reach the goal."], "<Way to play>", "Move       ", "Deside     ", "Are you sure you want to exit?", "Ended", "Language : English", "Exit       ", "Retry      ", "key", "keys", ["<Maze>", "Player : \"@\"", "Block  : \"■\"", "Route  : \" \"", "Goal   : \"\#\"", "Item   : \"+\""], "You can scroll", ["Start Game", "About Game", "Settings", "Exit"], ["Are you", "sure   ", "you    ", "want to",  "exit?  "], "Yes", "No", ["Are you", "sure   ", "you    ", "want to",  "retry? "], "Clear time : ", ["s", "m"], "Space key to continue.", ["You find", "a "], "Check items", "<items> ", ["(There's", "not a", "item)"], [["It shows", "you the ", "directio", "n to the", "goal    ", "once and", "for all."], ["It will ", "show you", "the dire", "ction to", "go once ", "in the  ", "place.  "], ["You can", "see far", "away", "until", "you move", "50times."], ["You can", "only", "move", "once,", "ignoring", "walls."]], ["Use", "Dump ", "Exit"], ["Used", "Disposed", "Exited"], ["Specify", "a direct", "ion and", "press", "the", "spacebar."]]
$words = [$English, $Japanese]
items_list = [["Exit", "", "compus", "navi", "torch", "ladder"], ["終了", "", "ｺﾝﾊﾟｽ", "ナビ", "松明", "はしご"]] # 半角6字以内
$item_numbers = [2, 3, 4, 5]

def deepcopy(list1)
  return Marshal.load(Marshal.dump(list1))
end

def clean
  puts "\e[0m\e[H\e[2J", ""
end

def pass
  n = 0
end

def screen_convert_to_blank(putter)
  clean
  for y in 0..11 + 2
    for x in 0..34
      if y > 1
        putter[y - 2][x] = " "
      end
      if y < 11
        putter[y][x] = "■"
      end
    end
    clean
    puts putter
    sleep(0.05)
  end
end

def screen_convert_from_blank(inter)
  clean
  putter = []
  for y in 0..11
    putter.push([])
    for x in 0..34
      putter[y].push(" ")
    end
  end

  for y in 0..11 + 2
    for x in 0..34
      if y > 1
        putter[y - 2][x] = inter[y - 2][x]
      end
      if y < 11
        putter[y][x] = "■"
      end
    end
    clean
    for y in 0..11
      puts putter[y].join
    end
    sleep(0.05)
  end
end

def wait_for_space
  while true
    if keyin == "space"
      break
    end
  end
end

def keyin
  $stdin.raw do |io|
    ch = io.readbyte
    keyinboards = [["a", "s", "d", "w", "space", "enter", "e", "r", "c"], [97, 115, 100, 119, 32, 13, 101, 114, 99]]
    if keyinboards[1].include?(ch.to_i)
      return keyinboards[0][keyinboards[1].index(ch.to_i)]
    else
      return ""
    end
  end
end

def start
  clean
  cursol_status = 0
  starter_hozon = []
  for i in 0..$words.length - 1
    starter_hozon.push($words[i][13].clone)
  end
  while true
    clean
    $starter = $words[$language][13].clone
    puts $dull_letter
    for i in 0..$starter.length - 1
      if i == cursol_status
        $starter[i] = "           > " + $starter[i].slice(starter_hozon[$language][i].length * -1..-1)
      else
        $starter[i] = "             " + $starter[i].slice(starter_hozon[$language][i].length * -1..-1)
      end
    end
    puts "", $starter
    key = keyin
    if key == "w"
      cursol_status = [0, cursol_status - 1].max
    elsif key == "s"
      cursol_status = [$starter.length - 1, cursol_status + 1].min
    elsif key == "space"
      case cursol_status
        when 0
          break
        when 1
          clean
          cutter = 0
          putter_hozon = ["<#{$words[$language][13][1]}>", 
          *$words[$language][0], 
          "", 
          *$words[$language][11], 
          "", 
          "#{$words[$language][1]}", 
          "#{$words[$language][2]} : WASD #{$words[$language][10]}", 
          "#{$words[$language][3]} : Space #{$words[$language][9]}", 
          "#{$words[$language][7]} : E #{$words[$language][9]}", 
          "#{$words[$language][8]} : R #{$words[$language][9]}", 
          "#{$words[$language][22]} : C #{$words[$language][9]}", 
          "", 
          "> #{$words[$language][13][3]}"]
          key = ""
          while key != "space"
            putter = putter_hozon.clone
            if cutter != 0
              putter[0 + cutter] = "↑   ↑   ↑   ↑  (#{$words[$language][12]})"
            end
            if cutter != putter.length - 12
              putter[11 + cutter] = "↓   ↓   ↓   ↓  (#{$words[$language][12]})"
            end
            clean
            puts putter[cutter..11 + cutter]
            key = keyin
            if key == "w" && cutter != 0
              cutter -= 1
            end
            if key == "s" && cutter != putter.length - 12
              cutter += 1
            end
          end
        when 2
          up_down_status = 1
          clean
          puts("<#{$words[$language][13][2]}>", 
          "",
          "> #{$words[$language][6]}", 
          "  #{$words[$language][13][3]}")
          key = ""
          while true
            clean
            if up_down_status == 1
              puts("<#{$words[$language][13][2]}>", 
              "",
              "> #{$words[$language][6]}", 
              "  #{$words[$language][13][3]}")
            else
              puts("<#{$words[$language][13][2]}>", 
              "",
              "  #{$words[$language][6]}", 
              "> #{$words[$language][13][3]}")
            end
            key = keyin
            if key == "w"
              up_down_status = 1
            elsif key == "s"
              up_down_status = 0
            elsif key == "space"
              if up_down_status == 1
                $language += 1
                if $language == $words.length
                  $language = 0
                end
              else
                break
              end
            end
          end
        when 3
          $exiter = 0
          key = ""
          while key != "space"
            clean
            puts("<#{$words[$language][13][3]}>", 
            "#{$words[$language][4]}", 
            "")
            if key == "w"
              $exiter = 1
            elsif key == "s"
              $exiter = 0
            end
            if $exiter == 1
              puts "> #{$words[$language][15]}"
              puts "  #{$words[$language][16]}"
            else
              puts "  #{$words[$language][15]}"
              puts "> #{$words[$language][16]}"
            end
            key = keyin
          end
        if $exiter == 1
          clean
          puts "<#{$words[$language][13][3]}>"
          puts "#{$words[$language][5]}"
          exit
        end
      end
    end
  end
end

def make_maze(x, y)
  maze = []
  for ky in 0..y - 1
    maze.push([])
    for kx in 0..x - 1
      maze[ky].push(1)
    end
  end
  mx, my = 1, 1
  maze[my][mx] = 0
  while true
    while true
      way = [[2, 0], [-2, 0], [0, 2], [0, -2]]
      can_way = way.select{|a| ((mx == 1 && a[0] == -2) || (my == 1 && a[1] == -2) || (mx == x - 2 && a[0] == 2) || (my == y - 2 && a[1] == 2)) == false && maze[my + a[1]][mx + a[0]] == 1}
      if can_way == []
        break
      end
      to_way = can_way[rand(can_way.length)]
      maze[my + to_way[1]][mx + to_way[0]] = 0
      maze[my + to_way[1] / 2][mx + to_way[0] / 2] = 0
      mx, my = mx + to_way[0], my + to_way[1]
    end
    next_plots = []
    for ky in 0..y - 1
      for kx in 0..x - -1
        if maze[ky][kx] == 0 && ky % 2 == 1 && kx % 2 == 1
          next_plots.push([kx, ky])
        end
      end
    end
    if next_plots.length == ((x - 1) / 2) * ((y - 1) / 2)
      break
    end
    next_plot = next_plots[rand(next_plots.length)]
    mx, my = next_plot[0], next_plot[1]
  end
  rare = [0, 0, 3, 2, 3, 1] # 大きいと出やすい
  for j in 2..rare.length - 1
    for i in 0..(x * y / 1800 * rare[j]).to_i
      maze = put_item(maze, j, x, y)
    end
  end
  maze[-2][-2] = 9
  return maze
end

def put_item(maze, item, ux, uy)
  maze[rand(1..(uy / 2).to_i) * 2 - 1][rand(1..(ux / 2).to_i) * 2 - 1] = item
  return maze
end

def screen(maze, nx, ny, cx, cy, torch)
  inter = []
  for y in cy..11 + cy
    putter = ""
    for x in cx..24 + cx
      if x == nx && y == ny
        putter += "@"
      else
        if ((nx - x).abs > 6 || (ny - y).abs > 3) && torch == 0
          putter += "-"
        else
          if maze[y][x] == 9
            putter += "\#"
          elsif maze[y][x] == 1
            putter += "■"
          elsif $item_numbers.include?(maze[y][x])
            putter += "+"
          elsif maze[y][x] == 0
            putter += " "
          else
            putter += maze[y][x].to_s
          end
        end
      end
    end
    putter += " :"
    inter.push(putter)
  end
  return inter
end

def right_clean(inter)
  for i in 0..12 - 1
    inter[i][27..34] = "        "
  end
  return inter
end

def right_screen(inter, rights)
  for i in 0..rights.length - 1
    inter[i][27..34] = rights[i]
  end
  for i in rights.length..12 - 1
    inter[i][27..34] = " " * 8
  end
  return inter
end

def navi(maze, nx, ny, ex, ey)
  maze1 = deepcopy(maze)
  maze1[ny][nx] = 1
  plots = [[], [], [], []]
  if maze1[ny][nx + 1] != 1
    plots[0].push([nx + 1, ny])
  end
  if maze1[ny + 1][nx] != 1
    plots[1].push([nx, ny + 1])
  end
  if maze1[ny][nx - 1] != 1
    plots[2].push([nx - 1, ny])
  end
  if maze1[ny - 1][nx] != 1
    plots[3].push([nx, ny - 1])
  end
  while true
    next_plots = [[], [], [], []]
    end_place = -1
    for i in 0..4 - 1
      if plots[i] != []
        plots[i] = plots[i].uniq
        for j in 0..plots[i].length - 1
          if maze1[plots[i][j][1]][plots[i][j][0] + 1] != 1
            next_plots[i].push([plots[i][j][0] + 1, plots[i][j][1]])
            if [plots[i][j][0] + 1, plots[i][j][1]] == [ex, ey]
              end_place = i
            end
            maze1[plots[i][j][1]][plots[i][j][0] + 1] = 1
          end
          if maze1[plots[i][j][1] + 1][plots[i][j][0]] != 1
            next_plots[i].push([plots[i][j][0], plots[i][j][1] + 1])
            if [plots[i][j][0], plots[i][j][1] + 1] == [ex, ey]
              end_place = i
            end
            maze1[plots[i][j][1] + 1][plots[i][j][0]] = 1
          end
          if maze1[plots[i][j][1]][plots[i][j][0] - 1] != 1
            next_plots[i].push([plots[i][j][0] - 1, plots[i][j][1]])
            if [plots[i][j][0] - 1, plots[i][j][1]] == [ex, ey]
              end_place = i
            end
            maze1[plots[i][j][1]][plots[i][j][0] - 1] = 1
          end
          if maze1[plots[i][j][1] - 1][plots[i][j][0]] != 1
            next_plots[i].push([plots[i][j][0], plots[i][j][1] - 1])
            if [plots[i][j][0], plots[i][j][1] - 1] == [ex, ey]
              end_place = i
            end
            maze1[plots[i][j][1] - 1][plots[i][j][0]] = 1
          end
        end
      end
    end
    plots = deepcopy(next_plots)
    if end_place != -1
      break
    end
  end
  end_placer = [">", "v", "<", "^"]
  return end_placer[end_place]
end

def torch_put_out(torch)
  if torch > 0
    torch -= 1
  end
  return torch
end

def ladder(maze, inter, nx, ny, cx, cy, torch)
  way = -1
  wayto = [[0, -1], [0, 1], [-1, 0], [1, 0]]
  maze_hozon = deepcopy(maze)
  mazes = [maze_hozon[ny - 1][nx], maze_hozon[ny + 1][nx], maze_hozon[ny][nx - 1], maze_hozon[ny][nx + 1]]
  while true
    rights = $words[$language][28]
    right_clean(inter)
    inter = right_screen(inter, rights)
    inter = screen(maze, nx, ny, cx, cy, torch)
    clean
    puts inter
    key = keyin
    maze[ny - 1][nx] = mazes[0]
    maze[ny + 1][nx] = mazes[1]
    maze[ny][nx - 1] = mazes[2]
    maze[ny][nx + 1] = mazes[3]
    if key == "w" && ny != 1
      maze[ny - 1][nx] = "^"
      way = 0
    elsif key == "s" && ny != maze.length - 1 - 1
      maze[ny + 1][nx] = "v"
      way = 1
    elsif key == "a" && nx != 1
      maze[ny][nx - 1] = "<"
      way = 2
    elsif key == "d" && nx != maze[ny].length - 1 - 1
      maze[ny][nx + 1] = ">"
      way = 3
    elsif key == "space" && way != -1
      maze[ny + wayto[way][1]][nx + wayto[way][0]] = 0
      break
    end
  end
  maze[ny - 1][nx] = mazes[0]
  maze[ny + 1][nx] = mazes[1]
  maze[ny][nx - 1] = mazes[2]
  maze[ny][nx + 1] = mazes[3]
  inter = right_clean(inter)
  nx += wayto[way][0]
  ny += wayto[way][1]
  return nx, ny
end

$language = 0
while true # mainloop
  torch = 0
  ender = 0
  retryer = 0
  items = [3, 4]
  $dull_letter = [" " * 35, "       ■■■■■          ■■  ■■", "       ■■  ■■         ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■■■■    ■■■■  ■■  ■■"]
  start
  putter = $dull_letter + [" " * 35] + $starter.map{|x| x + " " * (35 - x.length)}
  screen_convert_to_blank(putter)
  clean
  puts [""] * 11 + [" " * 20 + "Loading..."]
  nx, ny = 1, 1
  cx, cy = 0, 0
  maze = make_maze(45, 33)
  goal = [maze[0].length - 2, maze.length - 2]
  puts [""] * 11 + [" " * 19 + "Game Start!"]
  sleep(0.5)
  inter = screen(maze, nx, ny, cx, cy, torch)
  inter = inter.map{|x| x + " " * 8}
  screen_convert_from_blank(inter)
  timer = Time.now
  while true
    items = items.sort
    if nx < 12
      cx = 0
    elsif nx >= maze[0].length - 12
      cx = maze[0].length - 25
    else
      cx = nx - 12
    end
    if ny < 6
      cy = 0
    elsif ny >= maze.length - 6
      cy = maze.length - 12
    else
      cy = ny - 6
    end
    clean
    inter_hozon = inter.clone
    inter = screen(maze, nx, ny, cx, cy, torch)
    i = -1
    inter = inter.map do |x|
      i = i + 1
      x = x + inter_hozon[i][27..34]
    end
    puts inter
    if nx == maze[0].length - 2 && ny == maze.length - 2
      break
    end
    key = keyin
    if key == "w" && maze[ny - 1][nx] != 1 && ender == 0 && retryer == 0
      ny -= 1
      inter = right_clean(inter)
      torch = torch_put_out(torch)
    elsif key == "s" && maze[ny + 1][nx] != 1 && ender == 0 && retryer == 0
      ny += 1
      inter = right_clean(inter)
      torch = torch_put_out(torch)
    elsif key == "a" && maze[ny][nx - 1] != 1 && ender == 0 && retryer == 0
      nx -= 1
      inter = right_clean(inter)
      torch = torch_put_out(torch)
    elsif key == "d" && maze[ny][nx + 1] != 1 && ender == 0 && retryer == 0
      nx += 1
      inter = right_clean(inter)
      torch = torch_put_out(torch)
    elsif key == "e" || ender != 0 && retryer == 0
      if ender == 0
        ender = 2
      elsif key == "s"
        ender = 2
      elsif key == "w"
        ender = 1
      elsif key == "space"
        if ender == 1
          break
        else
          for i in 0..12 - 1
            inter[i][27..34] = " " * 7
          end
        end
        ender = 0
      end
      if ender != 0
        for i in 0..$words[$language][14].length - 1
          inter[i][27..34] = $words[$language][14][i]
        end
        if ender == 1
          inter[10][27..34] = "> #{$words[$language][15]}"
          inter[11][27..34] = "  #{$words[$language][16]}"
        else
          inter[10][27..34] = "  #{$words[$language][15]}"
          inter[11][27..34] = "> #{$words[$language][16]}"
        end
      end
    elsif key == "r" || ender == 0 && retryer != 0
      if retryer == 0
        retryer = 2
      elsif key == "s"
        retryer = 2
      elsif key == "w"
        retryer = 1
      elsif key == "space"
        if retryer == 1
          retryer = 0 
          nx, ny = 1, 1
          for i in 0..12 - 1
            inter[i][27..34] = " " * 7
          end
        else
          for i in 0..12 - 1
            inter[i][27..34] = " " * 7
          end
        end
        retryer = 0
      end
      if retryer != 0
        for i in 0..$words[$language][17].length - 1
          inter[i][27..34] = $words[$language][17][i]
        end
        if retryer == 1
          inter[10][27..34] = "> #{$words[$language][15]}"
          inter[11][27..34] = "  #{$words[$language][16]}"
        else
          inter[10][27..34] = "  #{$words[$language][15]}"
          inter[11][27..34] = "> #{$words[$language][16]}"
        end
      end
    elsif key == "c"
      cursol_status = 0
      while true
        righter = [$words[$language][23]]
        items.push(0) # exit
        if items.length == 1
          righter += $words[$language][24]
          righter.push(" >" + $words[$language][7])
        else
          for i in 0..[items.length, 10].min - 1
            if cursol_status == i
              righter.push("> #{items_list[$language][items[i]]}")
            else 
              righter.push("  #{items_list[$language][items[i]]}")
            end
          end
        end
        items = items[0..-2]
        inter = right_screen(inter, righter)
        clean
        puts inter
        key = keyin
        if key == "w" && cursol_status != 0
          cursol_status -= 1
        elsif key == "s" && cursol_status != items.length
          cursol_status += 1
        elsif key == "space"
          if cursol_status == items.length + 1 - 1
            inter = right_clean(inter)
            break
          else
            cursol_status_local = 0
            cursol_camera = 0
            while true
              if cursol_status_local + cursol_camera >= 10
                cursol_camera += 1
              end
              if cursol_status_local - cursol_camera <= -1
                cursol_camera -= 1
              end
              righter = [$words[$language][23]]
              righter.push(items_list[$language][items[cursol_status]])
              righter += $words[$language][25][items[cursol_status] - 2]
              for i in cursol_camera..$words[$language][26].length - 1 + cursol_camera
                if i == cursol_status_local
                  righter.push("> " + $words[$language][26][i])
                else
                  righter.push("  " + $words[$language][26][i])
                end
              end
              print(righter)
              inter = right_screen(inter, righter)
              clean
              puts inter
              key = keyin
              if key == "w" && cursol_status_local != 0
                cursol_status_local -= 1
              elsif key == "s" && cursol_status_local != $words[$language][26].length - 1
                cursol_status_local += 1
              elsif key == "space"
                case cursol_status_local
                  when 0
                    if items[cursol_status] == 2
                      pass
                    elsif items[cursol_status] == 3
                      maze[ny][nx] = navi(maze, nx, ny, goal[0], goal[1])
                    elsif items[cursol_status] == 4
                      torch = 50
                    elsif items[cursol_status] = 5
                      nx, ny = ladder(maze, inter, nx, ny, cx, cy, torch)
                    end
                    inter = screen(maze, nx, ny, cx, cy, torch)
                    items.delete_at(cursol_status)
                    inter = right_clean(inter)
                    inter[0][27..34] = $words[$language][27][0]
                    clean
                    puts inter
                    wait_for_space
                  when 1
                    items.delete_at(cursol_status)
                    inter = right_clean(inter)
                    inter[0][27..34] = $words[$language][27][1]
                    clean
                    puts inter
                    wait_for_space
                end
                break
              end
            end
          end
        elsif key == "c"
          inter = right_clean(inter)
          break
        end
      end
    end


    if $item_numbers.include?(maze[ny][nx])
      for i in 0..$words[$language][21].length - 1 - 1
        inter[i][27..34] = "#{$words[$language][21][i]}"
      end
      inter[$words[$language][21].length - 1][27..34] = "#{$words[$language][21][-1]}" + items_list[$language][maze[ny][nx]]
      items.push(maze.clone[ny][nx])
      maze[ny][nx] = 0
    end
  end
  if ender == 0
    times = Time.now - timer
    sleep(0.5)
    screen_convert_to_blank(inter)
    clean
    s = times.round(2)
    m = (s / 60).to_i
    s = (s % 60).round(2)
    puts "#{$words[$language][18]}#{m}#{$words[$language][19][1]} #{s}#{$words[$language][19][0]}"
    puts "#{$words[$language][20]}"
    wait_for_space
  else
    sleep(0.5)
    screen_convert_to_blank(inter)
  end
  ender = 0
  $dull_letter = [" " * 35, "       ■■■■■          ■■  ■■", "       ■■  ■■         ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■  ■■  ■■ ■■  ■■  ■■", "       ■■■■■    ■■■■  ■■  ■■"]
  putter = $dull_letter + [" " * 35] + $starter.map{|x| x + " " * (35 - x.length)}
  screen_convert_from_blank(putter)
end