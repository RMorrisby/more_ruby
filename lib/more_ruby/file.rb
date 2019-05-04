
class File
    # Returns the file's basename without its extension 
    def self.basename_no_ext f
        File.basename(f, File.extname(f))
    end
end
