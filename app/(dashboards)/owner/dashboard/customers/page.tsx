import { Suspense } from 'react';
import Pagination from "@/app/ui/customers/pagination";
import Search from "@/app/ui/search";
import Table from "@/app/ui/customers/table";
import LimitFilter from '@/app/ui/customers/limitFilter';
import { CustomersTableSkeleton } from "@/app/ui/skeletons";
import { lusitana } from "@/app/ui/fonts";
import { fetchCustomersPages } from "@/app/lib/data";
import { DEFAULT_CUSTOMERS_LIMIT } from "@/app/lib/config";

export default async function CustomersPage(props: {
    searchParams: Promise<{
        query?: string;
        page?: string;
        limit?: string;
    }>;
}) {
    // Await the searchParams promise
    const resolvedSearchParams = await props.searchParams;
    const query = resolvedSearchParams?.query || '';
    const currentPage = Number(resolvedSearchParams?.page) || 1;
    const limit = Number(resolvedSearchParams?.limit) || DEFAULT_CUSTOMERS_LIMIT;

    // Fetch totalPages dynamically
    const totalPages = await fetchCustomersPages(query, limit);

    return (
        <div className="w-full">
            <div className="flex w-full items-center justify-between">
                <h1 className={`${lusitana.className} text-2xl`}>Customers</h1>
            </div>
            <div className="mt-4 flex items-center justify-between gap-2 md:mt-8">
                <Search placeholder="Search customers..." />
                <LimitFilter />
            </div>
            <Suspense key={query + currentPage} fallback={<CustomersTableSkeleton />}>
                <Table query={query} currentPage={currentPage} limit={limit} />
            </Suspense>
            <div className="mt-5 flex w-full justify-center">
                <Pagination totalPages={totalPages} />
            </div>
        </div>
    );
}
