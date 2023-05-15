import 'package:bloc/bloc.dart';
import 'package:ditonton/features/movie/domain/entities/movie_detail.dart';
import 'package:ditonton/features/movie/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailCubit({required GetMovieDetail movieDetail})
      : getMovieDetail = movieDetail,
        super(MovieDetailInitial());

  void fetchMovieDetail(int id) async {
    emit(MovieDetailLoading());

    final result = await getMovieDetail.execute(id);

    result.fold((l) => emit(MovieDetailFailed(message: l.message)),
        (r) => emit(MovieDetailLoaded(movieDetail: r)));
  }
}
