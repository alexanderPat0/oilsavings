// class GasStations {


//     EN CUANTO CONSIGA RECOGER LA INFORMACIÓN CON LA API
//     TENGO QUE ENCONTRAR QUÉ INFORMACIÓN EXACTA ME VA A DEVOLVER
//     PARA INTRODUCIRLA AQUÍ Y PODER MOSTRAR LA INFORMACIÓN DE LAS 
//     GASOLINERAS CERCANAS.
//   bool? success;
//   List<UserData>? data;
//   String? message;

//   GasStations({this.success, this.data, this.message});

//   GasStations.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     if (json['data'] != null) {
//       data = <UserData>[];
//       json['data'].forEach((v) {
//         data!.add(UserData.fromJson(v));
//       });
//     }
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = message;
//     return data;
//   }
// }

// class GasStationData {

 


//   int? id;
//   String? username;
//   String? email;
//   String? mainFuel;
//   int? emailConfirmed;
//   DateTime? emailVerifiedAt;
//   String? password;
//   int? rememberToken;
//   int? deleted;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   UserData(
//       {this.id,
//       this.username,
//       this.email,
//       this.mainFuel,
//       this.emailConfirmed,
//       this.emailVerifiedAt,
//       this.password,
//       this.rememberToken,
//       this.deleted,
//       this.createdAt,
//       this.updatedAt});

//   UserData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['username'];
//     email = json['email'];
//     mainFuel = json['mainFuel'];
//     emailConfirmed = json['email_confirmed'];
//     emailVerifiedAt = json['email_verified_at'];
//     password = json['password'];
//     rememberToken = json['remember_token'];
//     deleted = json['deleted'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['username'] = username;
//     data['email'] = email;
//     data['mainFuel'] = mainFuel;
//     data['email_confirmed'] = emailConfirmed;
//     data['email_verified_at'] = emailVerifiedAt;
//     data['password'] = password;
//     data['remember_token'] = rememberToken;
//     data['deleted'] = deleted;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
