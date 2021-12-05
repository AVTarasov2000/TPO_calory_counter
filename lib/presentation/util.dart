double intOrDefault(var o, double d){
  if(o is double){
    return o;
  }
  var res = num.tryParse(o.toString());

  if(res != null){
    return res.toDouble();
  }
  return d;
}