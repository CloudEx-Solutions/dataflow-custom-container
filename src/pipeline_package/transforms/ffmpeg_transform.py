import os
import apache_beam as beam
import subprocess
from pipeline_package.utils.common_utils import log


class ExtractThumbnailFn(beam.DoFn):
    def process(self, element):
        # element is a GCS path like gs://bucket/video.mp4, or a local file path
        input_file = element
        if not os.path.exists(input_file):
            yield f"Error: {input_file} not found in {os.getcwd()}"
            return
        cmd = [
            "ffprobe", "-v", "error",
            "-select_streams", "v:0",
            "-show_entries", "stream=width,height",
            "-of", "csv=s=x:p=0",
            input_file
        ]

        try:
            result = subprocess.run(cmd, capture_output=True, check=True)
            yield f"Success! {input_file} resolution is: {result.stdout.decode().strip()}"
        except subprocess.CalledProcessError as e:
            yield f"FFmpeg Error: {e.stderr.decode()}"
        except FileNotFoundError:
            yield "Error: ffmpeg/ffprobe is not installed on your local system path."
