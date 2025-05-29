#!/bin/bash

# -------------------------------------------------------------------
# Script: adjust_pdf_contrast.sh
# Purpose: Batch process all PDF files in the current directory,
#          adjust their brightness and contrast, and save them
#          as new PDFs in the 'output' directory.
#
# How it works:
# 1. Converts each PDF page into images (JPEG or PNG)
# 2. Applies brightness-contrast adjustment to each image
# 3. Combines the adjusted images back into a single PDF
# 4. Stores the result in the output/ folder
# 5. Deletes temporary files after each PDF is processed
#
# How to adjust:
# - Change the BRIGHTNESS_CONTRAST value to control visual effect
# - Lower the DENSITY value to improve speed and reduce output size
# - Change PNG to JPG for faster processing and smaller output
# - Use parallel processing for large batches (manual extension)
# -------------------------------------------------------------------

# Set brightness and contrast values (e.g., "20x20" or "-10x30")
BRIGHTNESS_CONTRAST="20x20"

# Set image resolution for PDF rasterization (150–300 recommended)
DENSITY=100

# Choose image format: png (higher quality) or jpg (faster/smaller)
IMAGE_FORMAT="jpg"

# Output directory for final adjusted PDFs
OUTPUT_DIR="output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through all PDF files in the current directory
for pdf in *.pdf; do
  echo "Processing: $pdf"

  # Create temporary working folder
  mkdir -p tmp

  # Convert PDF pages to images
  convert -density "$DENSITY" "$pdf" "tmp/page_%03d.$IMAGE_FORMAT"

  # Apply brightness and contrast adjustment
  mogrify -brightness-contrast "$BRIGHTNESS_CONTRAST" tmp/*."$IMAGE_FORMAT"

  # Combine adjusted images into a new PDF
  convert tmp/*."$IMAGE_FORMAT" -quality 90 "$OUTPUT_DIR/$pdf"

  # Clean up temporary files
  rm -r tmp

  echo "Saved adjusted PDF to $OUTPUT_DIR/$pdf"
done

echo "✅ All PDFs processed."
