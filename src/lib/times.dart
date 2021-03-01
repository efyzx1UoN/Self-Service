class Times {
  int hour;
  int minute;

  Times(String string){
    String value = "";
    string = string.substring(0,string.length-2);
    for (int i=0;i<string.length;i++){
      if (string.substring(i,i+1)==":"){
        this.hour = int.parse(value);
        value = "";
        continue;
      }
      else{
        value += string.substring(i,i+1);
      }
    }
    this.minute = int.parse(value);
  }
}
