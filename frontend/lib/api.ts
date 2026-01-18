const API_URL = "http://localhost:3001/api/v1";

export interface Article {
  id: number;
  title: string;
  body: string;
  movie_id: number;
  published: boolean;
  created_at: string;
  updated_at: string;
}

export interface Movie {
  id: number;
  imdb_id: string;
  title: string;
  poster_url: string;
  year: string;
  created_at: string;
  updated_at: string;
}

export interface Rating {
  id: number;
  score: number;
  movie_id: number;
}

export interface OmdbMovie {
  Title: string;
  Year: string;
  imdbID: string;
  Poster: string;
  Type: string;
}

export const ratingsApi = {
  async changeRating(
    movieId: string,
    score: number,
    ratingId?: number,
  ): Promise<Rating> {
    const isUpdate = !!ratingId;
    const url = isUpdate
      ? `${API_URL}/ratings/${ratingId}`
      : `${API_URL}/movies/${movieId}/ratings`;

    const method = isUpdate ? "PUT" : "POST";
    const res = await fetch(url, {
      method: method,
      headers: getAuthHeaders(),
      body: JSON.stringify({
        movie_id: movieId,
        score: score,
      }),
    });
    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.errors?.join(", ") || "Failed to create");
    }
    return res.json();
  },
};

export const moviesApi = {
  async search(query: string): Promise<OmdbMovie[]> {
    const res = await fetch(
      `${API_URL}/movies?query=${encodeURIComponent(query)}`,
      {
        headers: getAuthHeaders(),
        cache: "no-store",
      },
    );
    if (!res.ok) throw new Error("Failed to search movies");
    return await res.json();
  },

  async getOne(imdbID: string): Promise<Movie[]> {
    const res = await fetch(`${API_URL}/movies/${imdbID}`, {
      headers: getAuthHeaders(),
      cache: "no-store",
    });
    if (!res.ok) throw new Error("Failed to fetch movie");
    return res.json();
  },
};

// Helper function to get auth headers
function getAuthHeaders(): HeadersInit {
  const headers: HeadersInit = {
    "Content-Type": "application/json",
  };

  // Get token from localStorage if available
  if (typeof window !== "undefined") {
    const token = localStorage.getItem("authToken");
    if (token) {
      headers["Authorization"] = `Bearer ${token}`;
    }
  }

  return headers;
}

export const articlesApi = {
  async getAll(id: number): Promise<Article[]> {
    const res = await fetch(`${API_URL}/articles/`, {
      headers: getAuthHeaders(),
      cache: "no-store",
    });
    if (!res.ok) throw new Error("Failed to fetch articles");
    return res.json();
  },

  async getOne(id: number): Promise<Article> {
    const res = await fetch(`${API_URL}/articles/${id}`, {
      headers: getAuthHeaders(),
      cache: "no-store",
    });
    if (!res.ok) throw new Error("Failed to fetch article");
    return res.json();
  },

  async changeArticle(
    articleId?: number | undefined,
    article: Partial<Article>,
  ): Promise<Article> {
    const isUpdate = !!articleId;
    const url = isUpdate
      ? `${API_URL}/articles/${articleId}`
      : `${API_URL}/movies/${article.movie_id}/articles`;

    const method = isUpdate ? "PUT" : "POST";
    const res = await fetch(url, {
      method: method,
      headers: getAuthHeaders(),
      body: JSON.stringify({
        article,
      }),
    });
    if (!res.ok) {
      const error = await res.json();
      throw new Error(error.errors?.join(", ") || "Failed to create");
    }
    return res.json();
  },

  async delete(id: number): Promise<void> {
    const res = await fetch(`${API_URL}/articles/${id}`, {
      method: "DELETE",
      headers: getAuthHeaders(),
    });
    if (!res.ok) throw new Error("Failed to delete article");
  },
};
