class User {

  int id = 0;
  int height = 0;
  int weight = 0;
  int age = 0;
  int mode = 0;

  User(this.id, this.height, this.weight, this.age, this.mode);

  factory User.fromJson(Map<String, dynamic> json) => User(
    json["id"],
    json["height"],
    json["weight"],
    json["age"],
    json["mode"],
  );

  Map<String, dynamic> toJson() => {
  "id" : id,
  "height" : height,
  "weight" : weight,
  "age" : age,
  "mode" : mode
  };

}