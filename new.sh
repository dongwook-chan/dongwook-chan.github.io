# check the number of paramters
if [ "$#" -eq 0 ]; then
        echo "argument test:\tillegal number of parameters"
        exit 1
fi

# get current date
today=$(date +'%Y-%m-%d')
echo "current date:\t$today"

# 2 versions of title
title_tr=$(echo $1 | tr ' ' -)
title=$1

# evaluate file name
file_name="$today-$title_tr"
echo $file_name

# create file
file_dir="$PWD/_posts/$file_name.md"
if [ ! -f "$file_dir" ]; then
        echo "target file not found"
else
        echo "target file found"
        exit 1
fi

echo "create target file"
# write YAML Front Matter (https://tianqi.name/jekyll-TeXt-theme/docs/en/writing-posts)
echo "---"		            >> "$file_dir"
echo "title: $title"	    >> "$file_dir"
echo "key: dong-$title_tr"	>> "$file_dir"
echo "tags: ${@:2}"     	>> "$file_dir"
echo "---"		            >> "$file_dir"

if [ -f "$file_dir" ]; then
        echo "target file created"
else
        echo "failed to create target file"
        exit 1
fi
