import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mbm_elearning/Data/Repository/post_material_repo.dart';

class AddDataToApiEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAddDataToApi extends AddDataToApiEvent {
  final String? name;
  final String? desc;
  final String? type;
  final String? branch;
  final String? sem;
  final String? url;
  final String? approve;
  final String? subject;
  final File? file;
  final BuildContext context;
  FetchAddDataToApi(
    this.name,
    this.desc,
    this.type,
    this.branch,
    this.sem,
    this.url,
    this.approve,
    this.subject,
    this.file,
    this.context,
  );
}

class ResetAddDataToApi extends AddDataToApiEvent {}

class AddDataToApiState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddDataToApiIsFailed extends AddDataToApiState {}

class AddDataToApiIsLoading extends AddDataToApiState {}

class AddDataToApiIsSuccess extends AddDataToApiState {
  final output;
  AddDataToApiIsSuccess(this.output);

  @override
  List<Object> get props => [output];
}

class SignupGetOtpApiYetIsNotCall extends AddDataToApiState {}

class AddDataToApiBloc extends Bloc<AddDataToApiEvent, AddDataToApiState> {
  PostMaterialRepo allNetworkRequest;
  AddDataToApiBloc(this.allNetworkRequest)
      : super(SignupGetOtpApiYetIsNotCall()) {
    on<AddDataToApiEvent>((event, emit) async {
      if (event is FetchAddDataToApi) {
        emit(AddDataToApiIsLoading());
        try {
          var addDataToApiOut = await allNetworkRequest.postMaterialRequest(
            event.name,
            event.desc,
            event.type,
            event.branch,
            event.sem,
            event.url,
            event.approve,
            event.subject,
            event.file,
            event.context,
          );
          emit(AddDataToApiIsSuccess(addDataToApiOut));
        } catch (_) {
          print('error catch');
          print(_);
          emit(AddDataToApiIsFailed());
        }
      } else if (event is ResetAddDataToApi) {
        emit(SignupGetOtpApiYetIsNotCall());
      }
    });
  }
}
