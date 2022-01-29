import 'dart:core';
import 'dart:math';



 var list = ['1234','0000','2580','0852','5683','1907','1997','1111','5555','3838'];
 var element = getRandomElement(list);
 print(element) {
   // TODO: implement print
   throw UnimplementedError();
 }


T getRandomElement<T>(List<T> list) {
 final random = new Random();
 var i = random.nextInt(list.length);
 return list[i];
}

