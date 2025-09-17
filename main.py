import json
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions, StandardOptions
import apache_beam as beam
from pipeline_package.utils.common_utils import log
from pipeline_package.transforms.some_transform import DoSomething


def run(argv=None):
    log("Starting your Dataflow job...")

    # add common arguments if needed

    import argparse
    parser = argparse.ArgumentParser()

    known_args, pipeline_args = parser.parse_known_args(argv)


    pipeline_options = PipelineOptions(pipeline_args)
    pipeline_options.view_as(SetupOptions).save_main_session = True
    pipeline_options.view_as(StandardOptions).streaming = True

    with beam.Pipeline(options=pipeline_options) as p:
        numbers = (
            p
            | 'CreateNumbers' >> beam.Create([1, 2, 3, 4, 5, 6, 7]))
        numbers | "Make Some Trasnform" >> beam.ParDo(DoSomething())
        
if __name__ == '__main__':
    run()
