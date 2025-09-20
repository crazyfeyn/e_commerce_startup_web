// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? phoneNumber;
  String? password;
  bool? premium;
  DateTime? expiredDate;
  bool? telegramBot;
  String? chatId;
  String? botStep;
  String? botLang;
  bool? duration;
  String? source;
  String? partnerId;
  String? monthlyAmount;
  String? limitAmount;
  bool? userBlocked;
  bool? usedFree;
  DateTime? createAt;
  String? partnerName;
  String? paidMsg;
  String? limitCurrency;
  String? accessToken;
  bool? newUser;
  String? email;
  String? emailId;
  String? imageUrl;
  String? imageName;
  String? appLang;
  String? pinCode;
  bool? nimadir;

  UserModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.password,
    this.premium,
    this.expiredDate,
    this.telegramBot,
    this.chatId,
    this.botStep,
    this.botLang,
    this.duration,
    this.source,
    this.partnerId,
    this.monthlyAmount,
    this.limitAmount,
    this.userBlocked,
    this.usedFree,
    this.createAt,
    this.partnerName,
    this.paidMsg,
    this.limitCurrency,
    this.accessToken,
    this.newUser,
    this.email,
    this.emailId,
    this.imageUrl,
    this.imageName,
    this.appLang,
    this.pinCode,
    this.nimadir,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? password,
    bool? premium,
    DateTime? expiredDate,
    bool? telegramBot,
    String? chatId,
    String? botStep,
    String? botLang,
    bool? duration,
    String? source,
    String? partnerId,
    String? monthlyAmount,
    String? limitAmount,
    bool? userBlocked,
    bool? usedFree,
    DateTime? createAt,
    String? partnerName,
    String? paidMsg,
    String? limitCurrency,
    String? accessToken,
    bool? newUser,
    String? email,
    String? emailId,
    String? imageUrl,
    String? imageName,
    String? appLang,
    String? pinCode,
    bool? nimadir,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        premium: premium ?? this.premium,
        expiredDate: expiredDate ?? this.expiredDate,
        telegramBot: telegramBot ?? this.telegramBot,
        chatId: chatId ?? this.chatId,
        botStep: botStep ?? this.botStep,
        botLang: botLang ?? this.botLang,
        duration: duration ?? this.duration,
        source: source ?? this.source,
        partnerId: partnerId ?? this.partnerId,
        monthlyAmount: monthlyAmount ?? this.monthlyAmount,
        limitAmount: limitAmount ?? this.limitAmount,
        userBlocked: userBlocked ?? this.userBlocked,
        usedFree: usedFree ?? this.usedFree,
        createAt: createAt ?? this.createAt,
        partnerName: partnerName ?? this.partnerName,
        paidMsg: paidMsg ?? this.paidMsg,
        limitCurrency: limitCurrency ?? this.limitCurrency,
        accessToken: accessToken ?? this.accessToken,
        newUser: newUser ?? this.newUser,
        email: email ?? this.email,
        emailId: emailId ?? this.emailId,
        imageUrl: imageUrl ?? this.imageUrl,
        imageName: imageName ?? this.imageName,
        appLang: appLang ?? this.appLang,
        pinCode: pinCode ?? this.pinCode,
        nimadir: nimadir ?? this.nimadir,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    phoneNumber: json["phone_number"],
    password: json["password"],
    premium: json["premium"],
    expiredDate: json["expired_date"] == null ? null : DateTime.parse(json["expired_date"]),
    telegramBot: json["telegram_bot"],
    chatId: json["chat_id"],
    botStep: json["bot_step"],
    botLang: json["bot_lang"],
    duration: json["duration"],
    source: json["source"],
    partnerId: json["partner_id"],
    monthlyAmount: json["monthly_amount"],
    limitAmount: json["limit_amount"],
    userBlocked: json["user_blocked"],
    usedFree: json["used_free"],
    createAt: json["create_at"] == null ? null : DateTime.parse(json["create_at"]),
    partnerName: json["partner_name"],
    paidMsg: json["paid_msg"],
    limitCurrency: json["limit_currency"],
    accessToken: json["access_token"],
    newUser: json["new_user"],
    email: json["email"],
    emailId: json["email_id"],
    imageUrl: json["image_url"],
    imageName: json["image_name"],
    appLang: json["app_lang"],
    pinCode: json["pincode"],
    nimadir: json["nimadir"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone_number": phoneNumber,
    "password": password,
    "premium": premium,
    "expired_date": expiredDate?.toIso8601String(),
    "telegram_bot": telegramBot,
    "chat_id": chatId,
    "bot_step": botStep,
    "bot_lang": botLang,
    "duration": duration,
    "source": source,
    "partner_id": partnerId,
    "monthly_amount": monthlyAmount,
    "limit_amount": limitAmount,
    "user_blocked": userBlocked,
    "used_free": usedFree,
    "create_at": createAt?.toIso8601String(),
    "partner_name": partnerName,
    "paid_msg": paidMsg,
    "limit_currency": limitCurrency,
    "access_token": accessToken,
    "new_user": newUser,
    "email": email,
    "email_id": emailId,
    "image_url": imageUrl,
    "image_name": imageName,
    "app_lang": appLang,
    "pincode": pinCode,
    "nimadir": nimadir,
  };
}
