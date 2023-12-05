def remove_lines_starting_with(file_path, prefix):
    try:
        # Read the content of the file
        with open(file_path, 'r', encoding="utf8") as file:
            lines = file.readlines()

        # Remove lines starting with the specified prefix
        filtered_lines = [line for line in lines if not line.strip().startswith(prefix)]

        # Write the filtered lines back to the file
        with open(file_path, 'w', encoding="utf8") as file:
            file.writelines(filtered_lines)

        print(f"Lines starting with '{prefix}' removed successfully.")

    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
file_path = 'db/temp.sql'  # Replace with your file path
prefix_to_remove = '--'

remove_lines_starting_with(file_path, prefix_to_remove)