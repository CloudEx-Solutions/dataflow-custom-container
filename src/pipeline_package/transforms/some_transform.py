import apache_beam as beam
from pipeline_package.utils.common_utils import log

class DoSomething(beam.DoFn):
    def process(self, element):
        try:
            log(f"Some processing on: {element}")
            yield element 
        except Exception as e:
            log(f"Some error processing: {element}")
            
