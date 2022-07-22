import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbm_elearning/Data/Repository/get_mterial_repo.dart';
import 'package:mbm_elearning/Data/Repository/post_material_repo.dart';
import 'package:mbm_elearning/Provider/scrap_table_provider.dart';

class GetMaterialApiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGetMaterialApi extends GetMaterialApiEvent {
  final String sem;
  final String branch;
  final int? skip;
  final int? limit;
  final String type;
  final String query;
  final String userId;
  final String approve;
  final bool showProgress;
  final ScrapTableProvider scrapTableProvider;
  final bool getDataFromLiveSheet;
  FetchGetMaterialApi(
    this.sem,
    this.branch,
    this.skip,
    this.limit,
    this.type,
    this.query,
    this.userId,
    this.approve,
    this.showProgress,
    this.scrapTableProvider, {
    this.getDataFromLiveSheet = false,
  });
  @override
  List<Object> get props => [
        branch,
        sem,
        type,
        query,
        userId,
        approve,
        showProgress,
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
}

class GetMaterialApiNotCall extends GetMaterialApiState {}

class GetMaterialApiBloc
    extends Bloc<GetMaterialApiEvent, GetMaterialApiState> {
  GetMaterialRepo allNetworkRequest;
  GetMaterialApiBloc(this.allNetworkRequest) : super(GetMaterialApiNotCall());

  GetMaterialApiState get initialState => GetMaterialApiNotCall();

  @override
  Stream<GetMaterialApiState> mapEventToState(
      GetMaterialApiEvent event) async* {
    if (event is FetchGetMaterialApi) {
      if (event.scrapTableProvider.checkIsNotEmpty() &&
          !event.getDataFromLiveSheet) {
        if (event.query != '') {
          yield GetMaterialApiIsLoading();
          yield GetMaterialApiIsSuccess(
              event.scrapTableProvider.getMaterialsByQuary(event.query));
        } else if (event.sem != '' && event.type != '') {
          yield GetMaterialApiIsLoading();
          yield GetMaterialApiIsSuccess(event.scrapTableProvider
              .getMaterialsBySemesterAndBranch(event.sem, event.type,
                  branch: event.branch));
        } else if (event.userId != '') {
          yield GetMaterialApiIsSuccess(
              event.scrapTableProvider.getMaterialsByUserid(event.userId));
        }
      } else {
        if (event.showProgress) {
          yield GetMaterialApiIsLoading();
        }
        try {
          var output = await allNetworkRequest.getMaterialRequest(
            event.sem,
            event.branch,
            event.query,
            event.userId,
            event.approve,
            event.type,
            event.skip,
            event.limit,
          );
          yield GetMaterialApiIsSuccess(output);
        } catch (_) {
          log(_.toString());
          yield GetMaterialApiIsFailed();
        }
      }
    } else if (event is ResetGetMaterialApi) {
      yield GetMaterialApiNotCall();
    }
  }
}
