function character = morse2char(mc)
  character = '';
  switch mc
    case ".-"
      character = 'A';
      return
    case "-..."
      character = 'B';
      return
    case "-.-."
      character = 'C';
      return
    case "-.."
      character = 'D';
      return
    case "."
      character = 'E';
      return
    case "..-."
      character = 'F';
      return
    case "--."
      character = 'G';
      return
    case "...."
      character = 'H';
      return
    case ".."
      character = 'I';
      return
    case ".---"
      character = 'J';
      return
    case "-.-"
      character = 'K';
      return
    case ".-.."
      character = 'L';
      return
    case "--"
      character = 'M';
      return
    case "-."
      character = 'N';
      return
    case "---"
      character = 'O';
      return
    case ".--."
      character = 'P';
      return
    case "--.-"
      character = 'Q';
      return
    case ".-."
      character = 'R';
      return
    case "..."
      character = 'S';
      return
    case "-"
      character = 'T';
      return
    case "..-"
      character = 'U';
      return
    case "...-"
      character = 'V';
      return
    case ".--"
      character = 'W';
      return
    case "-..-"
      character = 'X';
      return
    case "-.--"
      character = 'Y';
      return
    case "--.."
      character = 'Z';
      return
    case ".----"
      character = '1';
      return
    case "..---"
      character = '2';
      return
    case "...--"
      character = '3';
      return
    case "....-"
      character = '4';
      return
    case "....."
      character = '5';
      return
    case "-...."
      character = '6';
      return
    case "--..."
      character = '7';
      return
    case "---.."
      character = '8';
      return
    case "----."
      character = '9';
      return
    case "-----"
      character = '0';
      return
  endswitch
endfunction