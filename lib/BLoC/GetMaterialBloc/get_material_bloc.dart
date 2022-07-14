import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbm_elearning/Data/Repository/AddAndGetDataFromApi.dart';

class GetMaterialApiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGetMaterialApi extends GetMaterialApiEvent {
  final String sem;
  final String branch;
  final int skip;
  final int limit;
  final String type;
  final String query;
  final String userId;
  final String approve;
  FetchGetMaterialApi(
    this.sem,
    this.branch,
    this.skip,
    this.limit,
    this.type,
    this.query,
    this.userId,
    this.approve,
  );
  @override
  List<Object> get props => [
        branch,
        sem,
        skip,
        limit,
        type,
        query,
        userId,
        approve,
      ];
}

class ResetGetMaterialApi extends GetMaterialApiEvent {}

class GetMaterialApiState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMaterialApiIsFailed extends GetMaterialApiState {}

class GetMaterialApiIsLoading extends GetMaterialApiState {}

class GetMaterialApiIsSuccess extends GetMaterialApiState {
  final output;
  GetMaterialApiIsSuccess(this.output);

  @override
  List<Object> get props => [output];
}

class SignupGetOtpApiYetIsNotCall extends GetMaterialApiState {}

class GetMaterialApiBloc
    extends Bloc<GetMaterialApiEvent, GetMaterialApiState> {
  AllNetworkRequest allNetworkRequest;
  GetMaterialApiBloc(this.allNetworkRequest)
      : super(SignupGetOtpApiYetIsNotCall());

  @override
  GetMaterialApiState get initialState => SignupGetOtpApiYetIsNotCall();

  @override
  Stream<GetMaterialApiState> mapEventToState(
      GetMaterialApiEvent event) async* {
    if (event is FetchGetMaterialApi) {
      yield GetMaterialApiIsLoading();

      try {
        var getMaterialApiOut = await allNetworkRequest.getMethodRequest(
          event.sem,
          event.branch,
          event.query,
          event.userId,
          event.approve,
          event.type,
          event.skip,
          event.limit,
        );
        yield GetMaterialApiIsSuccess(getMaterialApiOut);
      } catch (_) {
        log(_.toString());
        yield GetMaterialApiIsFailed();
      }
    } else if (event is ResetGetMaterialApi) {
      yield SignupGetOtpApiYetIsNotCall();
    }
  }
}
