import os
import difflib

def compare_folders(folder1, folder2, output_file):
    # Get the list of files in each folder
    files1 = os.listdir(folder1)
    files2 = os.listdir(folder2)

    # Sort the files to ensure they are in the same order
    files1.sort()
    files2.sort()

    with open(output_file, 'w') as output:
        for file1, file2 in zip(files1, files2):
            path1 = os.path.join(folder1, file1)
            path2 = os.path.join(folder2, file2)

            # Read the contents of each file
            with open(path1, 'r') as f1, open(path2, 'r') as f2:
                lines1 = f1.readlines()
                lines2 = f2.readlines()

            # Perform diff comparison
            diff = difflib.unified_diff(lines1, lines2, fromfile=path1, tofile=path2)
            diff_str = ''.join(diff)

            # Write the diff to the output file
            output.write(diff_str)
            output.write('\n')

# Define directories
folder1 = 'Data_markup'
folder2 = '../sources/SDT8'


output_file = 'diff_output.txt'

# Compare the folders and write the diff to the output file
compare_folders(folder1, folder2, output_file)

print("Diff comparison completed. Output written to", output_file)
