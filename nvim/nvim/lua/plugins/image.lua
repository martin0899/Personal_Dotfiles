return {
  {
    "3rd/image.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          only_render_image_at_cursor = true,
          download_remote_images = true,
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
        neorg = { enabled = false },
      },
      max_width = nil,
      max_height = nil,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
    keys = {
      { "<leader>mi", "<cmd>Image<CR>", desc = "Image picker (oil)" },
      { "<leader>mp", "<cmd>ImagePreview<CR>", desc = "Image preview" },
    },
    cmd = { "Image", "ImagePreview" },
    event = "BufReadPost",
  },
}
