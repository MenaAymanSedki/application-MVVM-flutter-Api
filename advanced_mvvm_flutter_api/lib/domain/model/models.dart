// onboarding
class SliderObject {
  String title;
  String SubTitle;
  String image;

  SliderObject(
      {required this.title, required this.SubTitle, required this.image});
}

class SliderViewObject {
  SliderObject sliderObject;
  int numberOfSlides;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numberOfSlides, this.currentIndex);
}

// login models

class Customer {
  int id;
  String name;
  int numOfNotification;
  Customer(this.id, this.name, this.numOfNotification);
}

class Contacts {
  String phone;
  String email;
  String link;
  Contacts(this.phone, this.email, this.link);
}

class Authentication {
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer, this.contacts);
}

class Service {
  int id;
  String title;
  String image;
  Service(this.id, this.title, this.image);
}

class BannerAd {
  int id;
  String title;
  String image;
  String link;
  BannerAd(this.id, this.title, this.image, this.link);
}

class Store {
  int id;
  String title;
  String image;
  Store(this.id, this.title, this.image);
}

class HomeDataModel {
  List<Service> services;

  List<BannerAd> banners;

  List<Store> stores;

  HomeDataModel(this.services, this.banners, this.stores);
}

class HomeObject {
  HomeDataModel data;
  HomeObject(this.data);
}

class StoreDetails {
  int id;
  String title;
  String image;
  String details;
  String services;
  String about;

  StoreDetails(
      this.id, this.title, this.image, this.details, this.services, this.about);
}