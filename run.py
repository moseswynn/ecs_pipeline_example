import click
import ecs_pipelines
import logging
import importlib

@click.command()
@click.option('--name','-n','pipeline_name')
@click.option('--stream/--pipeline', default=False)
def main(pipeline_name, stream):
    if not pipeline_name:
        raise ValueError("A pipeline name must be specified.")
    
    logging.info(f'Loading Job Runner for {"stream" if stream else "pipeline"} {pipeline_name}.')

    if stream:
        runner = importlib.import_module(f'ecs_pipelines.streams.{pipeline_name}', 'ecs_pipelines')
    else:
        runner = importlib.import_module(f'ecs_pipelines.batch.{pipeline_name}', 'ecs_pipelines')

    return runner.run()

if __name__ == "__main__":
    main()