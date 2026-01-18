"use client";

import { useParams, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { moviesApi, ratingsApi } from "@/lib/api";
import Modal from "@/app/components/Modal";
import Link from "next/link";

export default function MovieDetails() {
	const { id } = useParams();
	const [movieData, setMovieData] = useState(null);
	const [loading, setLoading] = useState(false);
	const [error, setError] = useState("");
	const [rating, setRating] = useState(1);
	const [ratingModal, showRatingModal] = useState(false);
	useEffect(() => {
		const fetchMovie = async () => {
			setLoading(true);
			try {
				const response = await moviesApi.getOne(id);
				setMovieData(response);
			} catch (error) {
				setError("Failed to fetch movie");
			} finally {
				setLoading(false);
			}
		};

		fetchMovie();
	}, [id]);

	const handleRatingSubmit = async () => {
		await ratingsApi.changeRating(id, Number(rating), userRating?.id);
		showRatingModal(false);
		const response = await moviesApi.getOne(id);
		setMovieData(response);
	};

	const handleUpdateRatingClick = () => {
		setRating(userRating.score); // ← Pre-fill with existing rating
		showRatingModal(true);
	};

	const movie = movieData?.movie;
	const userArticle = movieData?.user_article;
	const userRating = movieData?.user_rating;

	if (error) return <p className="status-message">{error}</p>;

	return (
		<div>
			{movie && (
				<div className="flex justify-between">
					<div className="space-y-4">
						<div className="flex flex-row space-x-2 items-center">
							<h2 className="font-bold text-lg">{movie.Title}</h2>
							<p className="font-semibold text-md">({movie.Year})</p>
						</div>
						<p>
							<strong>Directed By -</strong> {movie.Director}{" "}
						</p>
						<p>
							<strong>Genre -</strong> {movie.Genre}
						</p>
						<p>
							<strong>Plot -</strong> {movie.Plot}
						</p>
						<div>
							<h3 className="font-semibold text-md">Awards</h3>
							<p>{movie.Awards}</p>
						</div>
						<p>
							<strong>Box Office -</strong> {movie.BoxOffice}
						</p>
						<div>
							<h3 className="font-semibold text-md">Ratings</h3>
							{movie.Ratings.map((rating) => (
								<p>
									{rating.Source} - {rating.Value}
								</p>
							))}
							{userRating?.id && <p>Your rating - {userRating.score}</p>}
						</div>
						<div className="flex space-x-2 items-center">
							{userRating?.id ? (
								<button
									onClick={() => handleUpdateRatingClick()}
									className="bg-blue-500 cursor-pointer hover:bg-blue-700 text-white font-medium py-1 px-2 rounded focus:outline-none focus:shadow-outline"
								>
									Update Rating
								</button>
							) : (
								<button
									onClick={() => {
										setRating(1);
										showRatingModal(true);
									}}
									className="bg-blue-500 cursor-pointer hover:bg-blue-700 text-white font-medium py-1 px-2 rounded focus:outline-none focus:shadow-outline"
								>
									Add Rating
								</button>
							)}
							{userArticle ? (
								<Link
									href={`/movies/${movie.imdbID}/articles/${userArticle.id}/edit`}
									className="bg-blue-500 ursor-pointer hover:bg-blue-700 text-white font-medium py-1 px-2 rounded focus:outline-none focus:shadow-outline"
								>
									Update Review
								</Link>
							) : (
								<Link
									href={`/movies/${movie.imdbID}/articles/new`}
									className="bg-blue-500 ursor-pointer hover:bg-blue-700 text-white font-medium py-1 px-2 rounded focus:outline-none focus:shadow-outline"
								>
									Add Review
								</Link>
							)}
						</div>
					</div>
					<img src={movie.Poster} alt={movie.Title} />
					<Modal
						isOpen={ratingModal}
						key={movie.id}
						onClose={() => showRatingModal(false)}
						confirmText={userRating ? "Update Rating" : "Add Rating"}
						onConfirm={handleRatingSubmit}
						cancelText="Cancel"
						title="Rate Movie"
					>
						<div className="flex items-center space-x-2 text-gray-700">
							<label className="font-semibold text-md">Select Rating:</label>
							<input
								type="range"
								className="w-2/3"
								min="1"
								max="10"
								value={rating}
								onChange={(e) => setRating(e.target.value)}
							/>
						</div>
						<p className="text-gray-700">
							<strong>Rating:</strong> {rating}/10
						</p>
					</Modal>
				</div>
			)}
		</div>
	);
}
