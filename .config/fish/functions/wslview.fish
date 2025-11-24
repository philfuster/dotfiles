function wslview --description 'Open URLs in Windows browser from WSL2'
    # Simple URL opener for WSL2 using Windows native tools
    # Change to a Windows-friendly directory first to avoid UNC path issues
    set -l original_dir (pwd)
    cd /mnt/c
    cmd.exe /c start "" $argv[1]
    cd $original_dir
end
