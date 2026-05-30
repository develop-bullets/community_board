import 'dart:async';

import 'package:flutter/foundation.dart';

// AuthenticationBloc 의 Stream 을 go_router 가
// 감지할 수 있도록 변환해 주는 Helper Class
// AuthenticationBloc 의 상태가 변경될 때 마다 go_router 에게
// 상태가 바뀌었으니까 redirect 로직을 다시 실행해봐 라고 알려주는 역할을 합니다.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
