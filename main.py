import json
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions, StandardOptions
import apache_beam as beam
from pipeline_package.utils.common_utils import log
from pipeline_package.transforms.some_transform import DoSomething
from pipeline_package.transforms.ffmpeg_transform import ExtractThumbnailFn


def run(argv=None):
    # add common arguments if needed

    import argparse
    parser = argparse.ArgumentParser()

    known_args, pipeline_args = parser.parse_known_args(argv)

    pipeline_options = PipelineOptions(pipeline_args)
    pipeline_options.view_as(SetupOptions).save_main_session = True

    # For the demo we use streaming=false to process a single video
    pipeline_options.view_as(StandardOptions).streaming = False

    with beam.Pipeline(options=pipeline_options) as p:
        (p | "ffmpeg_example" >> beam.Create([
            '/app/sample.mp4',
        ]) | "ExtractThumbnail" >> beam.ParDo(ExtractThumbnailFn())
            | "PrintResult" >> beam.Map(lambda x: log(f'result : {x}')))


if __name__ == '__main__':
    run()
