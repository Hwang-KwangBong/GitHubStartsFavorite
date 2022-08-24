Features
========
- Using [RxSwift](https://github.com/reactiveX/Rxswift.git)
- Using [Moya](https://github.com/Moya/Moya)
- Using [Tabman](https://github.com/uias/Tabman)
- Using [Kingfisher](https://github.com/onevcat/Kingfisher)
- Using [RxGRDB](https://github.com/RxSwiftCommunity/RxGRDB)
- Using [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)

Architecture
============
- MVVM
------
![image](https://user-images.githubusercontent.com/111618993/186404825-472175e4-5009-4588-bc93-5a3790de9a18.png)

- DataManager
* API 리스트와 로컬 리스트 데이터 연동 및 관리는 DataManager를 통하여 갱신 되도록 구현하였습니다. (Singleton 패턴)

Requirements
============
- iOS 13+
- Swift 5
- SPM

Screenshots
===========
<img src="https://user-images.githubusercontent.com/111618993/186406406-4798109a-784e-4593-b8d5-c09290d29faa.PNG" width="30%" height="20%"></img>
<img src="https://user-images.githubusercontent.com/111618993/186406432-0cc6b638-d4ac-4562-a03c-f4aca1ea9ef5.PNG" width="30%" height="20%"></img>
<img src="https://user-images.githubusercontent.com/111618993/186406446-dc2b5e19-78b5-4105-a1f2-677467096bdf.PNG" width="30%" height="20%"></img>

개선사항
======
1. 시간제한으로 UI / UX 최적화 보다는 기능에 중점을 두었습니다. 
* 리스트 empty 화면 없습니다.
* 서버 API 통신 시 Loading 화면 없습니다.
2. 리스트 검색 시 빠르게 반복적으로 API 통신하면 오류 발생합니다.
* 정확한 원인 파악이 되지 않아서 0.3초 딜레이를 통하여 키패드 입력시 바로 통신하지 못하게 예외 처리하였습니다. (아마도 github api를 빠르게 호출하는 것을 방지하지 않았을까? 추측함)
3. 디자인 패턴 개선
* 현재는 기능이 많지 않아서 가장 기본적인 MVVM 패턴을 이용하였지만, 상황에 따라서 디자인패턴 변경도 고려해야 합니다.
4. 테스트 시간 부족
* 다양한 방식으로 테스트를 못 해 보았는 데, 시간 여건이 된다면 TDD 방식으로 개발해 보는 것도 괜찮을꺼 같습니다.
5. DataBase 개선
* DataBase는 기본적인 방법으로만 사용하였는 데, 상황에 따라서 최적화가 필요합니다. (RxGRDB는 처음 써 봤습니다.)
6. Favorite 아이콘을 구할 수 없어서 하트 모양을 대신하였습니다.
