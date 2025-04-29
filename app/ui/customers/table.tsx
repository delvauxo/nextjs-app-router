import Image from "next/image";
import { fetchFilteredCustomers } from "@/app/lib/data";
import { FormattedCustomersTable } from "@/app/lib/definitions";

export default async function CustomersTable({
  query,
  currentPage,
  limit,
}: {
  query: string;
  currentPage: number;
  limit: number;
}) {
  const customers: FormattedCustomersTable[] = await fetchFilteredCustomers(query, currentPage, limit);

  return (
    <div className="mt-6 flow-root">
      <div className="inline-block min-w-full align-middle">
        <div className="rounded-lg bg-gray-50 p-2 md:pt-0">
          <div className="md:hidden">
            {customers?.map((customer) => (
              <div
                key={customer.id}
                className="mb-2 w-full rounded-md bg-white p-4"
              >
                <div className="flex items-center justify-between border-b pb-4">
                  <div>
                    <div className="mb-2 flex items-center">
                      <Image
                        src={customer.image_url}
                        className="rounded-full"
                        width={28}
                        height={28}
                        alt={`${customer.name}'s profile picture`}
                      />
                      <p>{customer.name}</p>
                    </div>
                    <p className="text-sm text-gray-500">{customer.email}</p>
                  </div>
                </div>
                <div className="flex w-full items-center justify-between border-b py-5">
                  <div className="flex w-1/2 flex-col">
                    <p className="text-xs">Pending</p>
                    <p className="font-medium">{customer.total_pending}</p>
                  </div>
                  <div className="flex w-1/2 flex-col">
                    <p className="text-xs">Paid</p>
                    <p className="font-medium">{customer.total_paid}</p>
                  </div>
                </div>
                <div className="pt-4 text-sm">
                  <p>{customer.total_invoices} invoices</p>
                </div>
              </div>
            ))}
          </div>
          <table className="hidden min-w-full text-gray-900 md:table">
            <thead className="rounded-lg text-left text-sm font-normal">
              <tr>
                <th scope="col" className="px-4 py-5 font-medium sm:pl-6">Name</th>
                <th scope="col" className="px-3 py-5 font-medium">Email</th>
                <th scope="col" className="px-3 py-5 font-medium">Total Invoices</th>
                <th scope="col" className="px-3 py-5 font-medium">Total Pending</th>
                <th scope="col" className="px-4 py-5 font-medium">Total Paid</th>
              </tr>
            </thead>
            <tbody className="bg-white">
              {customers?.map((customer) => (
                <tr key={customer.id} className="border-b py-3 text-sm">
                  <td className="whitespace-nowrap py-3 pl-6 pr-3">
                    <div className="flex items-center gap-3">
                      <Image
                        src={customer.image_url}
                        className="rounded-full"
                        width={28}
                        height={28}
                        alt={`${customer.name}'s profile picture`}
                      />
                      <p>{customer.name}</p>
                    </div>
                  </td>
                  <td className="whitespace-nowrap px-3 py-3">{customer.email}</td>
                  <td className="whitespace-nowrap px-3 py-3">{customer.total_invoices}</td>
                  <td className="whitespace-nowrap px-3 py-3">{customer.total_pending}</td>
                  <td className="whitespace-nowrap px-3 py-3">{customer.total_paid}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
