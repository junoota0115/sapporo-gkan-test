class Cms::TempFile
  include SS::Model::File
  include SS::Reference::Site
  include Cms::Reference::Node
  include SS::UserPermission
  include Cms::Lgwan::File

  validates_with Cms::FileSizeValidator, if: ->{ size.present? && @cur_node.present? }

  default_scope ->{ where(model: "ss/temp_file") }
  # default_scope ->{ where(model: "cms/temp_file") }

  private

  def presence_node_id
    false
  end
end
