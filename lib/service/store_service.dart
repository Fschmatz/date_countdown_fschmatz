import '../main.dart';
import '../redux/actions.dart';

abstract class StoreService {
  Future<void> loadCountdowns() async {
    await store.dispatch(LoadCountdownsAction());
  }
}
