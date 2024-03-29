class SS::TempFile
  include SS::Model::File
  include SS::UserPermission
  include Cms::Lgwan::File

  default_scope ->{ where(model: "ss/temp_file") }

  def remove_file
    Fs.rm_rf(path)
    remove_public_file
  end
end
