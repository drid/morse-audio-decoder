function upsatDecode(packet, source, timestamp)
  if strncmp(packet, "UPSAT", 5) == 0
    printf("Not an UPSat packet. exiting\n")
    return
  endif
  %Header
  printf "\n-------- UPSat telemetry ----------\n"
  
  % Source 
  printf ("Source: %s/\n", source)
  printf ("%s\n", timestamp)
  
  % packet
  printf ("%s %s\n", packet(1:5), packet(6:end))
  % Battery voltage
  if packet(6) == "0"
    printf ("Battery voltage: No Data\n");
   else
    printf ("Battery voltage: %d - %d mV\n", (packet(6)-65)*200+8000, (packet(6)-64)*200+8000);
  endif
  
  % Battery current
  if packet(7) == "0"
    printf ("Battery voltage: No Data\n");
   else
    printf ("Battery current: %d - %d mA\n", (packet(7)-65)*80-1000, (packet(7)-64)*80-1000);
   endif
    
  % COMMS Temperature
  switch packet(8)
    case "A"
      printf ("COMMS Temp: < -10\n");
    break;
    case "Z"
      printf ("COMMS Temp: > 50\n");
    break;
    case "0"
      printf ("COMMS Temp: No Data\n");
    break;
    otherwise
      printf ("COMMS Temp: %d - %d °C\n", (packet(8)-65)*2-12, (packet(8)-64)*2-12);

  endswitch
  
  %COMMS Uptime
  commsUptimeH = ["0";"1";"2";"3";"4";"5";"6-8";"8-10";"10-12";"12-16";"16-20";"20-24";"24-30";"30-36";"36-44";"44-52";"52-60";"60-70";"70-80";"80-90";"90-100";"100-150";"150-200";"200-300";"300-400";">400"];
  if packet(9) == "0"
    printf ("COMMS Uptime (h): No Data\n");
   else
    printf ("COMMS Uptime (h): %s\n", commsUptimeH(packet(9)-64,:));
  endif
  
  if packet(10) == "0"
    printf ("COMMS Uptime (m): No Data\n");
  elseif packet(10) > "P"
    printf ("COMMS Uptime (m): %d - %d\n", (packet(10)-"P"-1)*4+20, (packet(10)-"P")*4+20);
  elseif packet(10) > "L"
    printf ("COMMS Uptime (m): %d - %d\n", (packet(10)-"L")*2+10, (packet(10)-"L"+1)*2+10);
  else
    printf ("COMMS Uptime (m): %d\n", packet(10)-65);
  endif
  
  %COMMS Errors
  if size(packet) < 11 
    printf ("COMMS cont errors: #\n");
  else
    commsErrors = ["0;TX,;0;RX";"1;TX,;0;RX";"2;TX,;0;RX";">2;TX,;0;RX";"0;TX,;1;RX";"1;TX,;1;RX";"2;TX,;1;RX";">2;TX,;1;RX";"0;TX,;2;RX";"1;TX,;2;RX";"2;TX,;2;RX";">2;TX,;2;RX";"0;TX,;>2;RX";"1;TX,;>2;RX";"2;TX,;>2;RX";">2;TX,;>2"];
    if packet(11) == "0"
      printf ("COMMS cont errors: No Data\n");
    elseif packet(11) == "Z"
      printf ("COMMS cont errors: No Error\n");
    else 
      printf ("COMMS cont errors: %s\n", commsErrors(packet(11)-64,:));
    endif
  endif
  
  if size(packet) < 12 
    printf ("COMMS Last Error: #\n");
  else
    commsLastError = ["-8" ;"-7" ;"-6" ;"-5" ;"-4" ;"-3" ;"-2" ;"-1" ;"-56" ;"-55" ;"-54" ;"-53" ;"-52" ;"-51" ;"-61" ;"" ;"other"];
    if packet(12) == "0"
      printf ("COMMS Last Error: No Data\n");
    elseif packet(12) == "Z"
      printf ("COMMS Last Error: No Error\n");
    else
      printf ("COMMS Last Error: %s\n", commsLastError(packet(12)-64,:));
    endif
  endif
  %CRC
  if size(packet) < 13 return endif
  printf ("CRC: %d\n", packet(13))
endfunction