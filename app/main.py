import time
import chalk

print(f"can't steal {chalk.red('this')}!", end='', flush=True)

time.sleep(2)
print(chalk.cyan(" ...kinda"))
