interface SearchProps {
	placeholder?: string;
	input?: string;
	onChange: () => void;
	handleSearch: () => void;
}

export default function Search({
	placeholder,
	input,
	onChange,
	handleSearch,
}: SearchProps) {
	return (
		<div className="search-bar">
			<input
				type="text"
				placeholder={placeholder}
				value={input}
				onChange={onChange}
			/>
			<button onClick={handleSearch}>Search</button>
		</div>
	);
}
