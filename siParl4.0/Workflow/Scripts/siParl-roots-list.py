import os
from xml.etree.ElementTree import Element, SubElement, tostring
import xml.etree.ElementTree as ET

def create_xml_list_for_directory(folder_path):
    root = Element("documentsList")

    for filename in os.listdir(folder_path):
        if filename.endswith('.xml'):
            file_path = os.path.join(folder_path, filename)
            ref = SubElement(root, "ref")
            ref.text = file_path.replace('\\', '/')
            # Add newline after <ref>
            ref.tail = '\n'
    
    return tostring(root, encoding='utf-8')

folder_path = 'speech'

xml_output = create_xml_list_for_directory(folder_path)
file_name = 'siParl_root_files.xml'  # Output file name for primary directory
with open(file_name, 'w') as f:
    f.write(xml_output)
