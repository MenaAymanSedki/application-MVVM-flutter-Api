import 'package:advanced_mvvm_flutter_api/data/network/error_handler.dart';
import 'package:advanced_mvvm_flutter_api/data/response/responses.dart';

const Cache_Home_Key = "Cache_Home_Key";
const Cache_Home_INTERVAL =60*1000; // 1 minute cache in mills
const CACHE_STORE_DETAILS_KEY = "Cache_Store_Details_Key";
const CACHE_STORE_DETAILS_INTERVAL =60*1000; // 1 minute cache in mills

abstract class LocalDataSource{
  Future<HomeResponse> getHomeData();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  void clearCache();
  void removeFromCache(String key);
   Future<StoreDetailsResponse> getStoreDetails();
    Future<void> saveStoreDetailsToCache(StoreDetailsResponse response); 
}
 
 class LocalDataSourceImpl implements LocalDataSource{
  // run time cache
  Map<String,CachedItem> cacheMap = Map();
  @override
  Future<HomeResponse> getHomeData() async {
    CachedItem? cachedItem = cacheMap[Cache_Home_Key];
    if(cachedItem != null && cachedItem.isValid(Cache_Home_INTERVAL)){
      // return from response from cache
      return cachedItem.data;
    }else{
        // return an error that cache is not there or its not valid 
        throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }

    
  }
  
  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse)async {
    cacheMap[Cache_Home_Key] = CachedItem(homeResponse);
  }
  
  @override
  void clearCache() {
    cacheMap.clear();
  }
  
  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);

   
  }
  
  @override
  Future<StoreDetailsResponse> getStoreDetails() async {
    CachedItem? cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];

    if (cachedItem != null &&
        cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailsToCache(StoreDetailsResponse response) async {
    cacheMap[CACHE_STORE_DETAILS_KEY] = CachedItem(response);
  }

 }

 class CachedItem{
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
 }

 extension CachedItemExtention on CachedItem{
  bool isValid(int expirationTimeInMills){
      int CurrentTimeInMills = DateTime.now().millisecondsSinceEpoch;

      bool isValid = CurrentTimeInMills- cacheTime <= expirationTimeInMills;
      return isValid;
  }
 }

 