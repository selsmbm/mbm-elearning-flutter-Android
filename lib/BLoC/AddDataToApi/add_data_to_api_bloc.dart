import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbm_elearning/Data/Repository/AddAndGetDataFromApi.dart';

class AddDataToApiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAddDataToApi extends AddDataToApiEvent {
  final String _url;
  final Map _body;
  FetchAddDataToApi(this._url, this._body);
  @override
  List<Object> get props => [_body, _url];
}

class ResetAddDataToApi extends AddDataToApiEvent {}

class AddDataToApiState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddDataToApiIsFailed extends AddDataToApiState {}

class AddDataToApiIsLoading extends AddDataToApiState {}

class AddDataToApiIsSuccess extends AddDataToApiState {
  final signupOutput;
  AddDataToApiIsSuccess(this.signupOutput);

  @override
  List<Object> get props => [signupOutput];
}

class SignupGetOtpApiYetIsNotCall extends AddDataToApiState {}

class AddDataToApiBloc extends Bloc<AddDataToApiEvent, AddDataToApiState> {
  AllNetworkRequest allNetworkRequest;
  AddDataToApiBloc(this.allNetworkRequest)
      : super(SignupGetOtpApiYetIsNotCall());

  @override
  AddDataToApiState get initialState => SignupGetOtpApiYetIsNotCall();

  @override
  Stream<AddDataToApiState> mapEventToState(AddDataToApiEvent event) async* {
    if (event is FetchAddDataToApi) {
      yield AddDataToApiIsLoading();

      try {
        var addDataToApiOut =
            await allNetworkRequest.postMethodRequest(event._url, event._body);
        yield AddDataToApiIsSuccess(addDataToApiOut);
      } catch (_) {
        print('error catch');
        print(_);
        yield AddDataToApiIsFailed();
      }
    } else if (event is ResetAddDataToApi) {
      yield SignupGetOtpApiYetIsNotCall();
    }
  }
}
