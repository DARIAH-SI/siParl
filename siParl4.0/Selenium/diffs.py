import os
import subprocess

def compare_folders(folder1, folder2, output_file):
    files1 = sorted(os.listdir(folder1))
    files2 = sorted(os.listdir(folder2))

    with open(output_file, 'w') as output:
        for file1, file2 in zip(files1, files2):
            path1 = os.path.join(folder1, file1)
            path2 = os.path.join(folder2, file2)
            
            # Ensure both paths are files (you can add more checks as needed)
            if os.path.isfile(path1) and os.path.isfile(path2):
                # Perform diff comparison using subprocess and -w option
                result = subprocess.run(['diff', '-w', path1, path2], capture_output=True, text=True)
                diff_output = result.stdout

                # Write the diff to the output file
                output.write(f"Diff for {file1} and {file2}:\n")
                output.write(diff_output)
                output.write('\n\n')

# Define directories
folder1 = 'Data_markup'
folder2 = '../sources/SDT8'
output_file = 'diff_space_output.txt'

# Compare the folders and write the diff to the output file
compare_folders(folder1, folder2, output_file)

print("Diff comparison completed. Output written to", output_file)
