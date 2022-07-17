export file="$HOME/Download/"${{ inputs.file_name }}""
export output="$HOME/Files/"${{ inputs.file_name }}""

if [ "${{ inputs.action }}" = Hash ];then
    sha256sum "$file"
    md5sum "$file"
fi
if [ "${{ inputs.action }}" = Download ];then
    sha256sum "$file"
    md5sum "$file"
fi
if [ "${{ inputs.action }}" = Torrent ];then
    echo Installing torrenttools
    sudo add-apt-repository -y ppa:fbdtemme/torrenttools
    sudo apt-get -qq -y install torrenttools
    echo Making Torrent
    torrenttools create -v "hybrid" -o "$output.torrent" -w "${{ inputs.file_link }}" -c "${{ inputs.comment }}" -l "auto" -s "torrent-webseed-creator" "$file"
    echo Done
fi
if [ "${{ inputs.action }}" = Compress ];then
    if [ "${{ inputs.compress }}" = Tar ];then
        echo Compressing...
        tar -cvf "$output.tar" "$file"
        sha256sum "$output.tar"
        md5sum "$output.tar"
        echo Done
    fi
    if [ "${{ inputs.compress }}" = Zip ];then
        echo Compressing...
        zip -9 -q "$output.zip" "$file"
        sha256sum "$output.zip"
        md5sum "$output.zip"
        echo Done
    fi
    if [ "${{ inputs.compress }}" = 7z ];then
        echo Installing 7-Zip
        sudo apt update
        sudo apt install p7zip-full -y
        echo Compressing...
        7z a -mx=9 "$output.7z" "$file"
        sha256sum "$output.7z"
        md5sum "$output.7z"
        echo Done
    fi
    if [ "${{ inputs.compress }}" = Zstd ];then
        echo Compressing...
        zstd --ultra -22 "$file"
        mv "$file.zst" "$HOME/Files/"
        sha256sum "$output.zst"
        md5sum "$output.zst"
        echo Done
    fi
fi